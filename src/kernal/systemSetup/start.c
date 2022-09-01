#include "console/print.h"
#include <stdint.h>

void entry() {
	CONSOLE_resetScreen(CONSOLE_BLACK_BACK);

	const char* string1 = "OUI OUI\n";

	CONSOLE_print(string1, CONSOLE_BLUE_ON_BLACK, CONSOLE_FALSE);	
	const char* string = "NON NON\n";
	for (int a = 0; a < 23; a++)
		CONSOLE_print(string, CONSOLE_RED_ON_BLACK, CONSOLE_FALSE);	

	string = "<3<3<3<3<3<3<3<3\n";
	CONSOLE_print(string, CONSOLE_ORANGE_ON_BLACK, CONSOLE_FALSE);	

	string = ":):):):):):):)\n";
	CONSOLE_print(string, CONSOLE_BLUE_ON_BLACK, CONSOLE_FALSE);	

	string = ";););););););)\n";
	CONSOLE_print(string, CONSOLE_MAGENTA_ON_BLACK, CONSOLE_FALSE);	

	string = "WONDERFUL\n";
	CONSOLE_print(string, CONSOLE_MAGENTA_ON_BLACK, CONSOLE_FALSE);	
}

