compile: gen_hash utils
	mkdir -p bin
	gcc -g -c src/prgm.c -o src/prgm.o
	gcc -g src/prgm.o src/utils.o -o bin/aluemu

gen_hash:
	gperf src/gperf_opcodes.txt > src/hash.c

utils:
	gcc -g -c src/utils.c -o src/utils.o

test:
	./tests.sh

clean:
	rm src/*.o
	rm src/hash.c
	rm -rf out/
