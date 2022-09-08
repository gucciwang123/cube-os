#include <stdint.h>
#include "memory.h"

static volatile uint16_t* memEndPtr = (volatile uint16_t*) 0x9000;
static volatile MEM_ARRAY_ENTRY* memArray = (volatile MEM_ARRAY_ENTRY*) 0x9002;

uint16_t MEM_arraySize() {
	return *memEndPtr - (uint16_t) memArray;
}

volatile MEM_ARRAY_ENTRY* MEM_getArray() {
	return memArray;
}
