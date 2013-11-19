test: .PHONY
	# Should be failures to display/test failures.
	@./shunt.sh ./test/testOne.sh ./test/testTwo.sh

shml:
	wget https://raw.github.com/odb/shml/master/shml.sh

#shml:
	#bash ./scripts/update_shml.sh

.PHONY:
