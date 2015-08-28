double Java_test_TypeCasts_sintToDouble_1(int i){
	return (double) i;
}

unsigned Java_test_TypeCasts_doubleToUint_1(double d){
	return (unsigned) d;
}

char Java_test_TypeCasts_truncate_1(int i){
	return (char) i;
}

void Java_test_TypeCasts_execute_1(long i){
	void (*f) (void) = (void (*) (void)) i;
	f();
}

int Java_test_TypeCasts_harmless_0(int i){
	return i;
}
