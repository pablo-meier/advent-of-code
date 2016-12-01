
OUTPUT_NAME=manhattan_distance

compile:
	mlton -output $(OUTPUT_NAME) main.sml

run: compile
	./$(OUTPUT_NAME) input.txt

clean:
	rm -f $(OUTPUT_NAME)
