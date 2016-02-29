tests: prgm
	./tests.sh

prgm:
	mkdir -p bin
	ghc -o bin/irrigations src/irrigations.hs

clean:
	rm src/*.o
	rm src/*.hi
	rm bin/*
