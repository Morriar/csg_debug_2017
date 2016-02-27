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

#include "prgm.h"
#include <stdio.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <string.h>
#include "hash.c"

int main(int argc, char **argv)
{
	if(argc < 2) {
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
	start(lines);
}

void start(array* lines)
{
	int ln = lines->len;
	unsigned char state = 0;
	for(;ln-->0;){
		state = ops[hash(OPCODE(STRARR(lines)[ln]), strlen(OPCODE(STRARR(lines)[ln])))](state, STRARR(lines)[ln]);
	}
}

unsigned char add(unsigned char state, string* line) { return state + OPERAND(line); }

unsigned char sub(unsigned char state, string* line) { return state - OPERAND(line); }

unsigned char vmul(unsigned char state, string* line) { return state * OPERAND(line); }

unsigned char vdiv(unsigned char state, string* line) { return state / OPERAND(line); }

unsigned char prnt(unsigned char state, string* line) { printf("%hhu\n", state); return state; }

unsigned char mov(unsigned char state, string* line) {
	return OPERAND(line);
}

unsigned char band(unsigned char state, string* line) { return state & OPERAND(line); }

unsigned char bor(unsigned char state, string* line) { return state | OPERAND(line); }

unsigned char bxor(unsigned char state, string* line) { return state ^ OPERAND(line); }

unsigned char bnot(unsigned char state, string* line) { return ~state; }

unsigned char npow(unsigned char state, string* line) { unsigned char v = state - 1; v |= v >> 1; v |= v >> 2; v |= v >> 4; return v + 1; }

unsigned char cnt1(unsigned char state, string* line) { return bset[state]; }

unsigned char cnt0(unsigned char state, string* line) { return 8 - bset[state]; }

unsigned char err(unsigned char state, string* line) {
	printf("Error: unrecognized opcode/operand %s\n", OPCODE(line));
	exit(-1);
}
