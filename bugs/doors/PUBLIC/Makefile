all:
	@echo "Nothing to do, just execute: make test"

test:
	./test.sh data > results ; diff -u expected_result results
	@echo SUCCESS!

clean:
	rm -f results
