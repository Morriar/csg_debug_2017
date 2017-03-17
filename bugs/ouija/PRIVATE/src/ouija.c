#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

/* Hamming weight of `x`. see https://oeis.org/A000120 */
int bhd(unsigned char x) {
	int res = 0;
	for (int j = 0 ; j < 8; j++) {
		res += x & 1;
		x >>= 1; // BUG remove =
	}
	return res;
}

/* The hamming distance (of bits) between two byte sequences. */
int hamdist(const char *s1, const char *s2, size_t len) {
	int res = 0;
	for (size_t i = 0; i < len; i++) {
		unsigned char x = s1[i] ^ s2[i];
		res += bhd(x);
	}
	return res;
}

/* The average Hamming distance on slices of `klen` bytes. */
double score_keylen(const char *s, size_t klen, size_t slen) {
	double score = 0;
	int nb = 0;
	for(size_t i=0; i<slen; i+=klen)
		for(size_t j=0; j<slen; j+=klen) {
			if (i==j) continue;
			score += hamdist(s+i, s+j, klen) / (double)klen;
			nb += 1;
		}
	return score/nb;
}

/* The most probable length of the key. */
size_t search_keylen(const char *s, size_t len) {
	size_t best_len = 0;
	double best_score = 1.0/0.0;
	size_t max = len/2;
	if (max > 40) max = 40;
	for (size_t i=1; i<=max; i++) {
		double score = score_keylen(s, i, len);
		if (score < best_score) {
			best_score = score;
			best_len = i;
		}
	}
	return best_len;
}

/* A to Z frequency in English. */
double freqs[] = {
	0.0651738,
	0.0124248,
	0.0217339,
	0.0349835,
	0.1041442,
	0.0197881,
	0.0158610,
	0.0492888,
	0.0558094,
	0.0009033,
	0.0050529,
	0.0331490,
	0.0202124,
	0.0564513,
	0.0596302,
	0.0137645,
	0.0008606,
	0.0497563,
	0.0515760,
	0.0729357,
	0.0225134,
	0.0082903,
	0.0171272,
	0.0013692,
	0.0145984,
	0.0007836,
	0.1918182, // the space character
};

/* fill in `key` the most probable key. */
double crack_xor(const char *s, size_t slen, char *key, size_t klen) {
	double final_score = 0;
	for (size_t i = 0; i<klen; i++) {
		double best_score = 0;
		unsigned char best_byte = 0;
		for (int b=0; b<=255; b++) {
			size_t bf[27];
			memset(bf, 0, 27*sizeof(size_t));
			double score = 0;
			for(size_t j=i; j<slen; j+=klen) {
				char c = s[j] ^ b;
				if (c >= 'A' && c <= 'Z') score += freqs[c-'A'];
				else if (c >= 'a' && c <= 'z') score += freqs[c-'a'];
				else if (c == ' ') score += freqs[26]; // BUG: 27
				else continue;
			}
			if (score > best_score) {
				best_score = score;
				best_byte = b;
			}
		}
		if (key != NULL) key[i] = best_byte;
		final_score += best_score;
	}
	return final_score;
}

/* Vigenère cipher. */
void xor(char* input, size_t ilen, const char *key, size_t klen) {
	for (size_t i = 0; i < ilen; i++)
		input[i] ^= key[i%klen];
}

void printhex(const char *s, size_t len) {
	for(size_t i=0; i<len; i++)
		fprintf(stderr, "%02x", (int)(unsigned char)s[i]);
}

int debug = 1;

void do_crack(char *s, size_t len) {
	/* say no to drugs. */
	size_t klen = search_keylen(s, len);
	if (debug) fprintf(stderr, "keylen=%ld\n", klen);
	char key[klen];
	double score = crack_xor(s, len, key, klen);
	if (debug) {
		fprintf(stderr, "key=");
		printhex(key, klen);
		fprintf(stderr, " score=%f\n", score);
	}
	xor(s, len, key, klen);
	fwrite(s, 1, len, stdout);
}

/* Read a whole file. */
char *read_whole(const char *file, size_t *len) {
	FILE *f = fopen(file, "rb");
	if (f==NULL) {
		fprintf(stderr, "Cannot open %s: %s\n", file, strerror(errno));
		exit(1);
	}
	int err = fseek(f, 0, SEEK_END);
	if (err<0) {
		fprintf(stderr, "Cannot seek in %s: %s\n", file, strerror(errno));
		exit(1);
	}
	long fsize = ftell(f);
	rewind(f);

	char *string = malloc(fsize + 1);
	fread(string, fsize, 1, f);
	fclose(f);
	*len = fsize;
	return string;
}

/* holistically optimal block size */
#define BLOCK_SIZE 163840 // BUG add =

int main(int argc, char **argv) {
	char *file = argc>1 ? argv[1] : "/dev/urandom";

	FILE *f = fopen(file, "rb");
	if (f==NULL) {
		fprintf(stderr, "Cannot open %s: %s\n", file, strerror(errno));
		exit(1);
	}

	char s[BLOCK_SIZE];
	size_t len;
	if (argc>2) {
		/* Easter egg */
		size_t klen;
		char *k = read_whole(argv[2], &klen);
		if (debug) fprintf(stderr, "Encoding %d key\n", klen);

		do {
			len = fread(s, 1, BLOCK_SIZE, f);
			xor(s,len,k,klen);
			fwrite(s, 1, len, stdout);
		} while (len == BLOCK_SIZE);
		return 0;
	}

	do {
		len = fread(s, 1, BLOCK_SIZE, f);
		if (debug) fprintf(stderr, "Block %d\n", len);
		do_crack(s, len);
	} while (len == BLOCK_SIZE);

	return 0;
}
