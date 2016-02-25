compile: utils
	mkdir -p bin
	gcc -g -c src/prgm.c -o src/prgm.o
	gcc -g src/prgm.o src/utils.o -o bin/aluemu

utils:
	gcc -g -c src/utils.c -o src/utils.o

test:
	./tests.sh

clean:
	rm -rf src/*.o
	rm -rf out/
