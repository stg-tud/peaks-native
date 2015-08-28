#define DEBUG_TYPE "StaticAnalyses"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"

#include <iostream>
#include <fstream>
#include <unordered_set>

using namespace llvm;

namespace {
	
	/* Determines whether a call instance points to the JNI or the invocation API.
	 * Checks type through strings to avoid including files from OpenJDK. */
	bool javaCall(CallInst* cinst){
		// Get first operand, i.e. the structure the function call is performed on
		Value* fval = cinst->getArgOperand(0);
		// Get its type as a string
		Type* type = fval->getType();
		std::string st;
		raw_string_ostream stream(st);
		type->print(stream);
		std::string typeStr = stream.str();
		// Check the type for C/C++ JNI environment calls and 
		// VM calls (Invocation API) respectively
		if(	(typeStr.find("%struct.JNINativeInterface_*") != std::string::npos) || 
			(typeStr.find("%struct.JNIInvokeInterface_*") != std::string::npos)) {						
			return true;
		}
		else {
			return false;
		}
	}
	
	//===- FunctionalPurity - A pass checking functional purity ---------------===//
	
	struct FunctionalPurity : public ModulePass {
		static char ID;
		
		FunctionalPurity() : ModulePass(ID) {}
		
		/* The pass' core function */
		static bool functionalPurity(Function* function, std::unordered_set<std::string> hist){
			// Check for the readonly flag 
			if(!(function->onlyReadsMemory()))
				return false;
			// Iterate over the function's instructions
			for(inst_iterator I = inst_begin(function), E = inst_end(function); I != E; ++I){
				Instruction *inst = &*I;		
				// Check if any of the values used in the instruction is a global variable
				for(User::value_op_iterator v = inst->value_op_begin(), ve = inst->value_op_end(); v != ve; ++v){
					if(isa<GlobalVariable>(*v)){
						return false;
					}
				}
				// Check if the instruction could have additional side effects
				if(inst->mayThrow() || !inst->mayReturn()){
					return false;
				}
				// Check recursively if there are any function calls to impure functions
				if(CallInst* cinst = dyn_cast<CallInst>(inst)){
					// If we encounter a call to the Java part we conservatively assume non-purity
					if(javaCall(cinst)){						
						return false;
					}
					else{
						Function* cfunc = cinst->getCalledFunction();
						// Sometimes calls to NULL functions appear in dead code
						// Also avoid tracing loops
						if(cfunc != NULL && hist.count(cfunc->getName().data()) == 0){
							hist.insert(function->getName().data());
							if(!functionalPurity(cfunc, hist)){
								return false;
							}
							// Else continue search
						}
					}
				} 
			}
			// If we get here, the function is pure
			return true;					
		}
		
		/* The pass' top level function for individual pass execution */
		bool runOnModule(Module &M) override {
			std::ofstream logFile;
			logFile.open("FunctionalPurityLog.txt", std::ios::app);		
			std::unordered_set<std::string> hist;	
			// Iterate over the module
			for(Module::iterator f = M.begin(), fe = M.end(); f != fe; ++f){	
				if(Function* func = dyn_cast<Function>(&*f)){
					// Call the purity check on here defined functions that are called from Java
					if(!func->isDeclaration() && ((func->getName()).find("Java_") == 0)){				
						logFile << func->getName().data() << (functionalPurity(func, hist) ? " is pure" : " is impure") << "\n";
					}
				}		
			}
			logFile.close();
			return false;
		}
		
		/* We don't modify the program, so we preserve all analyses. */
		void getAnalysisUsage(AnalysisUsage &AU) const override {
			AU.setPreservesAll();
		}
	};
	
	//===- PointerArithmetics - A pass checking for pointer arithmetics ---------------===//
	
	struct PointerArithmetic : public ModulePass {
		static char ID;
		
		PointerArithmetic() : ModulePass(ID) {}
		
		/* Determine recursively if a pointer directly or indirectly points to a struct */
		static bool pointsToStruct(PointerType* type){
			if(isa<StructType>(type->getElementType()))
				return true;
			else if(PointerType * ptt = dyn_cast<PointerType>(type->getElementType()))
				return pointsToStruct(ptt);
			else
				return false;
		}
		
		/* The pass' core function */
		static bool pointerArithmetic(Function* function, std::unordered_set<std::string> hist){			
			// Iterate over the function's instructions
			for(inst_iterator I = inst_begin(function), E = inst_end(function); I != E; ++I){
				Instruction *inst = &*I;			
				// Look for getelementptr in the instruction			
				for(User::value_op_iterator v = inst->value_op_begin(), ve = inst->value_op_end(); v != ve; ++v){
					if(GetElementPtrInst* ptr = dyn_cast<GetElementPtrInst>(*v)){
						// Filter out the cases where an unmodified pointer is returned or a structure field is accessed
						if( !ptr->hasAllZeroIndices() &&
							!pointsToStruct((PointerType*) ptr->getPointerOperandType())) {
							// Pointer arithmetic found
							return true;
						}
					}
				}
				// Check recursively if there are any function calls to functions with pointer arithmetic
				if(CallInst* cinst = dyn_cast<CallInst>(inst)){
					// If we encounter a call to the Java part we know that no pointer arithmetics can happen there
					if(!javaCall(cinst)){						
						Function* cfunc = cinst->getCalledFunction();
						// Sometimes calls to NULL functions appear in dead code
						// Also avoid tracing loops
						if(cfunc != NULL && hist.count(cfunc->getName().data()) == 0){
							hist.insert(function->getName().data());
							if(pointerArithmetic(cfunc, hist)){
								return true;
							}
							// Else continue search
						}
					}
					// Java calls have no pointer arithmetic
				}
			}			
			// No pointer arithmetic found
			return false; 
		}				
		
		/* The pass' top level function for individual pass execution */
		bool runOnModule(Module &M) override {
			std::ofstream logFile;
			logFile.open("PointerArithmeticLog.txt", std::ios::app);		
			std::unordered_set<std::string> hist;	
			// Iterate over the module
			for(Module::iterator f = M.begin(), fe = M.end(); f != fe; ++f){	
				if(Function* func = dyn_cast<Function>(&*f)){
					// Call the pointer arithmetic check on here defined functions that are called from Java
					if(!func->isDeclaration() && ((func->getName()).find("Java_") == 0)){				
						logFile << func->getName().data() << (pointerArithmetic(func, hist) ? " has pointer arithmetic" : " has no pointer arithmetic") << "\n";
					}
				}		
			}
			logFile.close();
			return false;
		}
		
		/* We don't modify the program, so we preserve all analyses */
		void getAnalysisUsage(AnalysisUsage &AU) const override {
			AU.setPreservesAll();
		}
	};	
	
	//===- TypeCasts - A pass detecting pointer type casts ---------------===//
	
	struct TypeCasts : public ModulePass {
		static char ID;
		
		TypeCasts() : ModulePass(ID) {}
		
		/* The pass' core function */
		static bool typeCasts(Function* function, std::unordered_set<std::string> hist){
			// Iterate over the function's instructions
			for(inst_iterator I = inst_begin(function), E = inst_end(function); I != E; ++I){
				Instruction *inst = &*I;	
				// Check for pointer cast instances
				if(CastInst* cinst = dyn_cast<CastInst>(inst)){
					if(isa<IntToPtrInst>(cinst) || isa<PtrToIntInst>(cinst)){
						return true;
					}
				}
				// Check recursively if there are any function calls to functions with pointer type casts
				if(CallInst* cinst = dyn_cast<CallInst>(inst)){
					// If we encounter a call to the Java part we know that no explicit pointers exist there
					if(!javaCall(cinst)){						
						Function* cfunc = cinst->getCalledFunction();
						// Sometimes calls to NULL functions appear in dead code
						// Also avoid tracing loops
						if(cfunc != NULL && hist.count(cfunc->getName().data()) == 0){
							hist.insert(function->getName().data());
							if(typeCasts(cfunc, hist)){
								return true;
							}
							// Else continue search
						}
					}
					// Java calls have no pointers
				} 
			}
			// If we get here, there are no critical type casts
			return false;				
		}
		
		/* The pass' top level function for individual pass execution */
		bool runOnModule(Module &M) override {
			std::ofstream logFile;
			logFile.open("TypeCastsLog.txt", std::ios::app);		
			std::unordered_set<std::string> hist;	
			// Iterate over the module
			for(Module::iterator f = M.begin(), fe = M.end(); f != fe; ++f){	
				if(Function* func = dyn_cast<Function>(&*f)){
					// Call the type cast check on here defined functions that are called from Java
					if(!func->isDeclaration() && ((func->getName()).find("Java_") == 0)){				
						logFile << func->getName().data() << (typeCasts(func, hist) ? " has typecasts" : " has no typecasts") << "\n";
					}
				}		
			}
			logFile.close();
			return false;
		}
		
		/* We don't modify the program, so we preserve all analyses. */
		void getAnalysisUsage(AnalysisUsage &AU) const override {
			AU.setPreservesAll();
		}
	};

	//===- DynamicMemory - A pass detecting dynamic memory allocations ---------------===//
	
	struct DynamicMemory : public ModulePass {
		static char ID;
		
		DynamicMemory() : ModulePass(ID) {}
		
		/* Is the instruction "inst" a GEP call to get the address of the JNI function with index "index" in the table? */
		static bool JNIFuncWithIndLocated(Instruction * inst, unsigned index){
			for(User::value_op_iterator v = inst->value_op_begin(), ve = inst->value_op_end(); v != ve; ++v){
				if(GetElementPtrInst* ptr = dyn_cast<GetElementPtrInst>(*v)){
					PointerType * type = (PointerType *) ptr->getPointerOperandType();
					std::string st;
					raw_string_ostream stream(st);
					type->print(stream);
					std::string typeStr = stream.str();
					if((typeStr.find("%struct.JNINativeInterface_*") != std::string::npos) && ptr->getNumOperands() >= 3){
						unsigned gepInd = cast<ConstantInt>(ptr->getOperand(2))->getZExtValue();
						if(gepInd == index){
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/* Determines if the instruction is one that initiates the invocation of memory allocating or releasing functions in the JNI */
		static bool jniMem(Instruction * inst){
			// Indices of memory allocating or releasing functions in the JNI 
									// Get<PrimitiveType>ArrayElements and Release<PrimitiveType>ArrayElements
			unsigned JNIIndices [] = {183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198,
									// GetStringChars and ReleaseStringChars
									165, 166,
									// GetStringUTFChars and ReleaseStringUTFChars
									169, 170,
									// GetStringCritical and ReleaseStringCritical 
									224, 225,
									// GetPrimitiveArrayCritical and ReleasePrimitiveArrayCritical 
									222, 223,
									// NewGlobalRef and DeleteGlobalRef 
									21, 22,
									// NewLocalRef and DeleteLocalRef 
									25, 23,
									// PushLocalFram and PopLocalFrame 
									19, 20,
									// NewWeakGlobalRef and DeleteWeakGlobalRef 
									226, 227,
									// AllocObject
									27}; 
			// Calls the helper function with the instruction and each critical index
			for(unsigned long i = 0; i < (sizeof(JNIIndices) / sizeof(JNIIndices[0])); i++){
				if(JNIFuncWithIndLocated(inst, JNIIndices[i])){
					return true;
				}
			}
			return false;
		}			
		
		/* Determines if the function argument is a built-in dynamic memory allocation function of either C or C++ */
		static bool dynMem(Function * func){
			// The first four entries are C's dynamic memory functions, the next four are C++'s "new", "new[]", "delete" and "delete[]"
			const std::string dynMemFuncs [] = {"malloc", "calloc", "realloc", "free", "_Znwm", "_Znam", "_ZdlPv", "_ZdaPv"};
			
			// Compares the function's name with each critical name
			for(unsigned long i = 0; i < (sizeof(dynMemFuncs) / sizeof(dynMemFuncs[0])); i++) {
				if(func->getName() == dynMemFuncs[i]) {
					return true;
				}
			}
			return false;
		}
		
		/* The pass' core function */
		static bool dynamicMemory(Function* function, std::unordered_set<std::string> hist){
			// Iterate over the function's instructions 
			for(inst_iterator I = inst_begin(function), E = inst_end(function); I != E; ++I){
				Instruction *inst = &*I;
				// Check instruction for JNI dynamic memory allocation
				if(jniMem(inst)){
					return true;
				}
				// Check function calls
				if(CallInst* cinst = dyn_cast<CallInst>(inst)){
					// If we encounter a call to the Java part we assume that memory is correctly handled
					if(!javaCall(cinst)){						
						Function* cfunc = cinst->getCalledFunction();
						// Sometimes calls to NULL functions appear in dead code
						if(cfunc != NULL){
							// Check every call for calls to dynamic memory allocation functions
							if(dynMem(cfunc)){
								return true;
							}
							// Check recursively if there are any function calls to functions with dynamic memory allocations
							// Also avoid tracing loops
							else if(hist.count(cfunc->getName().data()) == 0){
								hist.insert(function->getName().data());
								if(dynamicMemory(cfunc, hist)){
									return true;
								}
								// Else continue search
							}
						}
					}
					// Java calls should manage dynamic memory correctly
				}
			}			
			// No dynamic memory allocations found
			return false; 
		}				
		
		/* The pass' top level function for individual execution */
		bool runOnModule(Module &M) override {
			std::ofstream logFile;
			logFile.open("DynamicMemoryLog.txt", std::ios::app);		
			std::unordered_set<std::string> hist;	
			// Iterate over the module
			for(Module::iterator f = M.begin(), fe = M.end(); f != fe; ++f){	
				if(Function* func = dyn_cast<Function>(&*f)){
					// Call the dynamic memory allocation check on here defined functions that are called from Java
					if(!func->isDeclaration() && ((func->getName()).find("Java_") == 0)){				
						logFile << func->getName().data() << (dynamicMemory(func, hist) ? " has dynamic memory allocation" : " has no dynamic memory allocation") << "\n";
					}
				}		
			}
			logFile.close();
			return false;
		}
		
		/* We don't modify the program, so we preserve all analyses */
		void getAnalysisUsage(AnalysisUsage &AU) const override {
			AU.setPreservesAll();
		}
	};
		//===- AllPasses - Runs all passes ---------------===//
	
	struct AllPasses : public ModulePass {
		static char ID;
		
		AllPasses() : ModulePass(ID) {}				
		
		/* Runs all the passes' core functions, writes into one file in CSV format */
		bool runOnModule(Module &M) override {
			std::ofstream logFile;
			logFile.open("AllLog.txt", std::ios::app);		
			std::unordered_set<std::string> hist;	
			// Iterate over the module
			for(Module::iterator f = M.begin(), fe = M.end(); f != fe; ++f){	
				if(Function* func = dyn_cast<Function>(&*f)){
					// Call the passes on here defined functions that are called from Java
					if(!func->isDeclaration() && ((func->getName()).find("Java_") == 0)){				
						logFile << 
						func->getName().data() <<
						(FunctionalPurity::functionalPurity(func, hist) ? " 0 " : " 1 ") <<
						(PointerArithmetic::pointerArithmetic(func, hist) ? " 1 " : " 0 ") <<
						(TypeCasts::typeCasts(func, hist) ? " 1 " : " 0 ") <<
						(DynamicMemory::dynamicMemory(func, hist) ? " 1" : " 0") << "\n";
					}
				}		
			}
			logFile.close();
			return false;
		}
		
		/* We don't modify the program, so we preserve all analyses */
		void getAnalysisUsage(AnalysisUsage &AU) const override {
			AU.setPreservesAll();
		}
	};
}

char AllPasses::ID = 0;
static RegisterPass<AllPasses> A("AllPasses",
"Runs all passes and formats output");

char FunctionalPurity::ID = 1;
static RegisterPass<FunctionalPurity> B("FunctionalPurity", 
"Checks functional purity of the given source code's methods");

char PointerArithmetic::ID = 2;
static RegisterPass<PointerArithmetic> C("PointerArithmetics", 
"Checks for pointer arithmetics in the given source code's methods");

char TypeCasts::ID = 3;
static RegisterPass<TypeCasts> D("TypeCasts",
"Checks for type casts in the given source code's methods");

char DynamicMemory::ID = 4;
static RegisterPass<DynamicMemory> E("DynamicMemory",
"Checks for dynamic memory allocations in the given source code's methods");
