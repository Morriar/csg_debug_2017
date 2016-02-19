all:
	@echo "Nothing to do, just execute: make test"

test:
	./test.sh > results ; diff -u expected_result results
	@echo SUCCESS!

clean:
	rm -f results
