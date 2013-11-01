test: .PHONY
	# Should be failures to display/test failures.
	./CLIunit.sh ./test/testOne.sh ./test/testTwo.sh
	./CLIunit.sh --no-style ./test/testOne.sh

clistyle:
	bash ./scripts/update_clistyle.sh

.PHONY:
