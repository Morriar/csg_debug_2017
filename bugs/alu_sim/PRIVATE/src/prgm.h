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

#define OPCODE(x) (to_cstring(STRARR(split(to_cstring(x), ' '))[0]))
#define OPERAND(x) atoi((to_cstring(STRARR(split(to_cstring(x), ' '))[1])))

static const unsigned char bset[256] = 
{
#   define B2(n) n,     n+1,     n+1,     n+2
#   define B4(n) B2(n), B2(n+1), B2(n+1), B2(n+2)
#   define B6(n) B4(n), B4(n+1), B4(n+1), B4(n+2)
	    B6(0), B6(1), B6(1), B6(2)
};

void start(array* lns);

unsigned char err(unsigned char state, string* line);
unsigned char add(unsigned char state, string* line);
unsigned char sub(unsigned char state, string* line);
unsigned char vmul(unsigned char state, string* line);
unsigned char vdiv(unsigned char state, string* line);
unsigned char prnt(unsigned char state, string* line);
unsigned char mov(unsigned char state, string* line);
unsigned char band(unsigned char state, string* line);
unsigned char bor(unsigned char state, string* line);
unsigned char bxor(unsigned char state, string* line);
unsigned char bnot(unsigned char state, string* line);
unsigned char npow(unsigned char state, string* line);
unsigned char cnt1(unsigned char state, string* line);
unsigned char cnt0(unsigned char state, string* line);

static unsigned char (*ops[29]) (unsigned char, string*) = {err,err,err,bnot,npow,err,err,err,bxor,prnt,err,err,bor,mov,cnt1,err,err,vdiv,band,cnt0,err,err,sub,add,err,err,err,err,vmul};
