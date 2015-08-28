#include <iostream>
#include <new>

extern "C" {
	
void Java_test_DynamicMemoryPP_new_1(int i){
	int * a = new int(i);
	std::cout << *a;
}

void Java_test_DynamicMemoryPP_delete_1(int * i){
	std::cout << *i;
	delete i;
}

void Java_test_DynamicMemoryPP_newArr_1(int i){
	int * a = new int[i];
	std::cout << *a;
}

void Java_test_DynamicMemoryPP_deleteArr_1(int * i){
	std::cout << *i;
	delete[] i;
}

void Java_test_DynamicMemoryPP_static_0(int i){
	int a = i;
	std::cout << a;
}
}
