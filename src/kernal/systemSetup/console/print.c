#include "print.h"
#include <stdint.h>

typedef struct {
	char text;
	CONSOLE_COLOR color;
} CHARACTOR;

static volatile CHARACTOR* videoMemory = (volatile CHARACTOR*) 0xb8000;

static uint8_t tabLen = 4;
static char tabChar = ' ';


int printString(CONSOLE_STRING text, CONSOLE_COLOR color, uint32_t offset, uint32_t* finalPosition) {
	uint64_t size = 0;

	while(text[size] != '\0')
		size++;

	uint32_t nextOffset = offset;

	for(int a = 0; a < size; a++) {
		if(text[a] == '\t') {
			for(int b = 0; b < tabLen; b++) {
				videoMemory[nextOffset].text = tabChar;
				videoMemory[nextOffset].color = color;
				nextOffset++;
			}
		}
		else if(text[a] == '\b') {
			nextOffset--;
			videoMemory[nextOffset].text = ' ';
			videoMemory[nextOffset].color = color;
		}
		else if(text[a] == '\n')
			nextOffset = (nextOffset - nextOffset % 80) + 80;
		else {
			videoMemory[nextOffset].text = text[a];
			videoMemory[nextOffset].color = color;
			nextOffset++;
		}
	}

	*finalPosition = nextOffset;
	return 0;
}

int CONSOLE_clearScreen(CONSOLE_COLOR color) {
	CHARACTOR block = {' ', color};

	for(int a = 0; a < 2000; a++)
		videoMemory[a] = block;

	return 0;
}

int CONSOLE_print(CONSOLE_STRING string, CONSOLE_COLOR color, CONSOLE_BOOL resetString) {
	static uint32_t cursorOffset = 0;

	if(resetString)
		cursorOffset = 0;

	printString(string, color, cursorOffset, &cursorOffset);

	if(cursorOffset >= 2000) {
		uint64_t buffer;
		uint64_t* des;

		uint32_t startOffset = 80 * (cursorOffset - 2000) / 80;
		startOffset = (startOffset - startOffset % 80) + 80;
		cursorOffset -= startOffset;

		for (int a = 0; a < 2000; a+= 4) {
			des = (unsigned long*) &videoMemory[a];
			buffer = *((unsigned long*)(&videoMemory[startOffset]));

			*des = buffer;

			startOffset += 4;
		}
	}

	return 0;
}

int CONSOLE_resetScreen(CONSOLE_COLOR color) {
	CONSOLE_clearScreen(color);
	CONSOLE_print("", 0, CONSOLE_TRUE);
	return 0;
}



