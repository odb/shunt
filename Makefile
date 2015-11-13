test: .PHONY
	# Should be failures to display/test failures.
	-@./shunt.sh ./test/testOne.sh ./test/testTwo.sh
	-@./shunt.sh --plain ./test/testOne.sh ./test/testTwo.sh
	-@./shunt.sh --verbose ./test/testOne.sh ./test/testTwo.sh

shml:
	bash ./scripts/update_shml.sh

.PHONY:
