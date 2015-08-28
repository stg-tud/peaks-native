struct stru{
		char a;
		int b;
};

int Java_test_PointerArithmetics_Structure_0(int input){
	struct stru test;
	test.b = input;
	return test.b++;
}

int Java_test_PointerArithmetics_Array_1(int input){
	int array[10];
	array[5] = 10;
	return array[5]++;
}

int* Java_test_PointerArithmetics_Array_0(int input){
	int array[10];
	int * ptr = array;
	return ptr;
}

int Java_test_PointerArithmetics_Pointer_1(int input){
	int a;
	int * ptr = &a;
	ptr += input;
	return *ptr;
}

int intermediate(int input){
	return Java_test_PointerArithmetics_Pointer_1(input);
}

int Java_test_PointerArithmetics_Call_1(int input){
	return intermediate(input);
}

int Java_test_PointerArithmetics_Call_0(int input){
	return *Java_test_PointerArithmetics_Array_0(input);
}
