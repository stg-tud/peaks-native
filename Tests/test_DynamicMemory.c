#include <stdio.h>
#include <stdlib.h>

void Java_test_DynamicMemory_malloc_1(int i){
	char * c = malloc(i);
	int j;
	for(j = 0; j < sizeof(c); j++){
		c[j] = 'a';
	}
	printf("%s",c);
}

void Java_test_DynamicMemory_calloc_1(int i){
	char * c = calloc(i,1);
	int j;
	for(j = 0; j < sizeof(c); j++){
		c[j] = 'a';
	}
	printf("%s",c);
}

void Java_test_DynamicMemory_realloc_1(int i){
	char * c = NULL;
	c = realloc(c,i);
	int j;
	for(j = 0; j < sizeof(c); j++){
		c[j] = 'a';
	}
	printf("%s",c);
}

void Java_test_DynamicMemory_free_1(char * c){
	int j;
	for(j = 0; j < sizeof(c); j++){
		c[j] = 'a';
	}
	printf("%s",c);
	free(c);
}

void Java_test_DynamicMemory_static_0(){
	char c [5];
	int j;
	for(j = 0; j < sizeof(c); j++){
		c[j] = 'a';
	}
	printf("%s",c);
}
