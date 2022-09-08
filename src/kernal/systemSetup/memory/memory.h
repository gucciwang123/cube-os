#pragma once

#include<stdint.h>

typedef struct{
	void* base;
	uint64_t size;
	uint32_t type;
	uint32_t ext_attrib;
} MEM_ARRAY_ENTRY;

int sortMemoryArray();
uint16_t MEM_arraySize();
volatile MEM_ARRAY_ENTRY* MEM_getArray();
