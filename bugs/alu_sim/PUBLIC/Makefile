# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (7 Gallium 369)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: R4PaSs

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
	rm -rf src/*.o
	rm -rf src/hash.c
	rm -rf out/
