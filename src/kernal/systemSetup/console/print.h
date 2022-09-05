#pragma once

#include <stdint.h>

//string type
typedef const char* CONSOLE_STRING;

//bool type
typedef unsigned char CONSOLE_BOOL;

#define CONSOLE_TRUE 1
#define CONSOLE_FALSE 0

//color attrib macro
typedef unsigned char CONSOLE_COLOR;

#define CONSOLE_RED_ON_BLACK 0b00000100
#define CONSOLE_GREEN_ON_BLACK 0b00000010
#define CONSOLE_BLUE_ON_BLACK 0b00000001
#define CONSOLE_WHITE_ON_BLACK 0b00001111
#define CONSOLE_ORANGE_ON_BLACK 0b00001100
#define CONSOLE_PURPLE_ON_BLACK 0b00000101
#define CONSOLE_MAGENTA_ON_BLACK 0b00001101

#define CONSOLE_ORANGE_ON_PURPLE 0b01011100
#define CONSOLE_MAGENTA_ON_PURPLE 0b01011101

#define CONSOLE_PURPLE_BACK 0b01010101
#define CONSOLE_BLACK_BACK 0b00000000
//end of color attrib macro definition

//start of function decloration
int CONSOLE_clearScreen(CONSOLE_COLOR color);
int CONSOLE_resetScreen(CONSOLE_COLOR color);

int CONSOLE_print(CONSOLE_STRING string, CONSOLE_COLOR color, CONSOLE_BOOL resetString);
int CONSOLE_hexPrint(uint64_t value, CONSOLE_COLOR color, CONSOLE_BOOL resetString);
