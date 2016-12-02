
OUTPUT_NAME_1=part1
OUTPUT_NAME_2=part2

compile:
	mlton -output $(OUTPUT_NAME_1) part1.sml
	mlton -output $(OUTPUT_NAME_2) part2.sml

run: compile
	./$(OUTPUT_NAME_1)
	./$(OUTPUT_NAME_2)

clean:
	rm -f $(OUTPUT_NAME_1)
	rm -f $(OUTPUT_NAME_2)
