test: .PHONY
	# Should be failures to display/test failures.
	./shunt.sh ./test/testOne.sh ./test/testTwo.sh

clistyle:
	bash ./scripts/update_clistyle.sh

.PHONY:
