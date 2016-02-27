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

#include <stdio.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"
#include "hash.c"

#define MAX(x, y) (((x) > (y))?(x):(y))

int main(int argc, char** argv)
{
	if(argc < 3) {
		printf("Usage ./prgm file.cstm\n");
		return 1;
	}
	FILE *fl = fopen(argv[1], "r");
	struct stat s;
	if(stat(argv[1], &s)) {
		printf("I/O error, are you sure %s is a valid file path ?\n", argv[1]);
		return -1;
	}
	char *data = malloc(s.st_size + 1);
	fread(data, s.st_size, 1, fl);
	data[s.st_size] = 0;
	fclose(fl);
	array *lines = split(data, '\n');
	char** hash_array;
	int max;
	int i;
	for(i = 0; i < lines->len; i++)
		max = MAX(hash(to_cstring(STRARR(lines)[i]), STRARR(lines)[i]->len), max);
	hash_array = malloc(sizeof(char*) * (max + 1));
	for(i = 0; i <= max; i++)
		hash_array[i] = "err";
	for(i = 0; i < lines->len; i++) {
		string* s = STRARR(lines)[i];
		int idx = hash(to_cstring(s), s->len);
		hash_array[idx] = to_cstring(s);
	}
	FILE *fo = stdout;
	char *header1 = "static unsigned char (*ops[";
	char max_str[10];
	memset(max_str, 0, 10);
	sprintf(max_str, "%d", max + 1);
	char *header2 = "]) (unsigned char, array*) = {";
	fwrite(header1, 1, strlen(header1), fo);
	fwrite(max_str, strlen(max_str), 1, fo);
	fwrite(header2, 1, strlen(header2), fo);
	for(i = 0; i < max; i++) {
		fwrite(hash_array[i], strlen(hash_array[i]), 1, fo);
		fwrite(",", 1, 1, fo);
	}
	fwrite(hash_array[max], strlen(hash_array[max]), 1, fo);
	fwrite("};", 1, 2, fo);
	printf("\n");
}
