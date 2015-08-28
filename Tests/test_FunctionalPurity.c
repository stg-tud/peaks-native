#include <stdio.h>

int global = 10;

struct stru{
	char a;
	int b;
};

int Java_test_FunctionalPurity_Simple_1(int a, int b){
	return a + b;
}

int Java_test_FunctionalPurity_AssToRefArg_0(int * input){
	*input = 0;
	return *input;
}

int Java_test_FunctionalPurity_AssToRefArg_1(int * input){
	int a = *input;
	a++;
	return a;
}

int Java_test_FunctionalPurity_UseGlobal_0(int input){
	return global;
}

int Java_test_FunctionalPurity_SideEffects_0(int input){
	printf("Test");
	return input;
}

int Java_test_FunctionalPurity_Call_0(int * input){
	return Java_test_FunctionalPurity_AssToRefArg_0(input);
}

int Java_test_FunctionalPurity_Call_1(int * input){
	return Java_test_FunctionalPurity_AssToRefArg_1(input);
}
