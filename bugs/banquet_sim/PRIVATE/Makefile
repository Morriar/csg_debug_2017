tests: prgm
	./tests.sh

prgm:
	mkdir -p bin
	ghc -o bin/banquet src/banquet.hs

clean:
	rm src/*.o
	rm src/*.hi
	rm bin/*
