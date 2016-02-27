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

#include "utils.h"
#include <stdlib.h>
#include <string.h>

array* split(char *data, char c)
{
	array* retard = malloc(sizeof(array) + sizeof(string*));
	retard->len = 0;
	retard->cap = 1;
	int ln = 0;
	while(*data != FALSE) {
		if(*data == c) {
			if(ln != FALSE) {
				string* s = malloc(sizeof(string));
				s->len = ln;
				s->str = data - ln;
				s->cstr = NULL;
				retard = arr_add(retard, s);
				ln = 0;
			}
			data++;
			continue;
		}
		data++;
		ln++;
	}
	if(ln != FALSE) {
		string* s = malloc(sizeof(string));
		s->len = ln;
		s->str = data - ln;
		s->cstr = NULL;
		retard = arr_add(retard, s);
		ln = 0;
	}
	return retard;
}

array* arr_add(array* arr, void* el)
{
	if(arr->len >= arr->cap) {
		int ncap = arr->len * 2;
		array* retard = malloc(sizeof(array) + ncap * sizeof(void*));
		memcpy(retard->elements, arr->elements, arr->len * sizeof(void*));
		retard->len = arr->len + 1;
		retard->cap = ncap;
		retard->elements[arr->len] = el;
		free(arr);
		return retard;
	}
	arr->elements[arr->len] = el;
	arr->len += 1;
	return arr;
}

char* to_cstring(string* s) {
	if(s->cstr != NULL) return s->cstr;
	char* cstr = calloc(s->len + 1, 1);
	memcpy(s->str, cstr, s->len);
	s->cstr = cstr;
	return cstr;
}


