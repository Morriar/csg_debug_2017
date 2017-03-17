#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

int hdb[] = {0, 1, 1, 2, 1, 2, 2};

int bhd(unsigned char x) {
	int res = 0;
	for (int j = 0 ; j < 8; j++) {
		res += x & 1;
		x >>= 1;
	}
	return res;
}

int hamdist(const char *s1, const char *s2, size_t len) {
	int res = 0;
	for (size_t i = 0; i < len; i++) {
		unsigned char x = s1[i] ^ s2[i];
		res += bhd(x);
	}
	return res;
}

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
	0.1918182,
};


double crack_xor(const char *s, size_t slen, char *key, size_t klen) {
	double final_score = 0;
	for (size_t i = 0; i<klen; i++) {
		double best_score = 0;//1/0.0;
		unsigned char best_byte = -1;
		for (int b=0; b<=255; b++) {
			size_t bf[27];
			memset(bf, 0, 27*sizeof(size_t));
			size_t len = 0;
#if 0
			for(size_t j=i; j<slen; j+=klen) {
				char c = s[j] ^ b;
				if ( c >= 'A' && c <= 'Z') bf[c-'A']++;
				else if ( c >= 'a' && c <= 'z') bf[c-'a']++;
				else if (c == ' ') bf[26]++;
				else continue;
				len++;
			}
			double score = 0;
			for(int j=0;j<27;j++) {
				double d = freqs[j] - bf[j] / (double)len;
				score += d*d;
				//printf("*** %d %02x? %d %f %f\n", i, b, j, d, score);
			}
			//printf("** %d %02x? %f a=%d/%d %f\n", i, b, score, bf[0], len, bf[0]/ (double)len);
			if (score < best_score) {
				best_score = score;
				best_byte = b;
			}
#else
			double score = 0;
			for(size_t j=i; j<slen; j+=klen) {
				char c = s[j] ^ b;
				if ( c >= 'A' && c <= 'Z') score += freqs[c-'A'];
				else if ( c >= 'a' && c <= 'z') score += freqs[c-'a'];
				else if (c == ' ') score += freqs[26];
				else continue;
				len++;
			}
			//printf("** %d %02x? %f a=%d/%d %f\n", i, b, score, bf[0], len, bf[0]/ (double)len);
			if (score > best_score) {
				best_score = score;
				best_byte = b;
			}

#endif
		}
		//printf("* %d %02x %f\n", i, best_byte, best_score);
		if (key != NULL) key[i] = best_byte;
		final_score += best_score;
	}
	return final_score;
}

void cpt_freq(const char *s, size_t slen) {
	size_t bf[27];
	memset(bf, 0, 27*sizeof(size_t));
	size_t len = 0;
	for(size_t j=0; j<slen; j++) {
		char c = s[j];
		if ( c >= 'A' && c <= 'Z') bf[c-'A']++;
		else if ( c >= 'a' && c <= 'z') bf[c-'a']++;
		else if (c == ' ') bf[26]++;
		len++;
	}
	double score = 0;
	for(int j=0;j<27;j++) {
		double f = bf[j] / (double)len;
		double d = freqs[j] - f;
		score += d*d;
		fprintf(stderr, "* %d %d/%d=%f d=%f\n", j, bf[j], len, f, d);
	}
	fprintf(stderr, "* score=%f\n", score);
}

void xor(char* input, size_t ilen, const char *key, size_t klen) {
	for (size_t i = 0; i < ilen; i++)
		input[i] ^= key[i%klen];
}


char *read_whole(const char *file, size_t *len) {
	FILE *f = fopen(file, "rb");
	if (f==NULL) { fprintf(stderr, "Cannot open %s: %s\n", file, strerror(errno)); exit(1);}
	int err = fseek(f, 0, SEEK_END);
	if (err<0) { fprintf(stderr, "Cannot seek in %s: %s\n", file, strerror(errno)); exit(1);}
	long fsize = ftell(f);
	rewind(f);

	char *string = malloc(fsize + 1);
	fread(string, fsize, 1, f);
	fclose(f);
	*len = fsize;
	return string;
}

void printhex(const char *s, size_t len) {
	for(size_t i=0; i<len; i++) {
		fprintf(stderr, "%02x", (int)(unsigned char)s[i]);
	}
}

int main(int argc, char **argv) {
	size_t len;
	char *s = read_whole(argv[1], &len);

	if (argc>2) {
		size_t klen;
		char *k = read_whole(argv[2], &klen);
		fprintf(stderr, "Encoding %d with %d key\n", len, klen);
		xor(s,len,k,klen);
		fwrite(s, 1, len, stdout);
		return 0;
	}

	//s = strdup("Hello the world!"); len = strlen(s);
	//char *k = "123";
	//xor(s,strlen(s),k,strlen(k));
	size_t klen = search_keylen(s, len);
	fprintf(stderr, "keylen %ld\n", klen);
	char key[klen];
	double score = crack_xor(s, len, key, klen);
	fprintf(stderr, "key="); printhex(key, klen); fprintf(stderr, " score=%f\n", score);
	xor(s, len, key, klen);
	cpt_freq(s,len);
	fwrite(s, 1, len, stdout);


	return 0;
}
