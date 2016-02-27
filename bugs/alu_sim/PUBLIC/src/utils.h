/*
 * Copyright Dome Systems.
 *
 * Dome Private License (D-PL) [a369] PubPL 36 (25 Osmium 287)
 *
 * * URL: http://csgames.org/2016/dome_license.md
 * * Type: Software
 * * Media: Software
 * * Origin: Mines of Morriar
 * * Author: R4PaSs
*/

#define TRUE 0
#define FALSE 1
#define PSTR(x) (fwrite(((x))->str, ((x))->len, 1, stdout))
#define STRARR(x) ((string**)(x)->elements)

typedef struct string {
	int len;
	char* str;
	char* cstr;
} string;

typedef struct array {
	int len;
	int cap;
	void* elements[1];
} array;

array* split(char* str, char c);
array* arr_add(array* arr, void* el);
char* to_cstring(string* s);
