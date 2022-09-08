#pragma once

#include <stdint.h>

#define NULL 0x0

#define TRUE 0x1
#define FALSE 0x0

typedef uint8_t BOOL;

#define GDT_NULL 0x0
#define GDT_CODE 0x8
#define GDT_DATA 0x10
