
EXEC1_NAME=day6part1
EXEC2_NAME=day6part2

run: build
	echo "Part 1" && ./$(EXEC1_NAME)
	echo "Part 2" && ./$(EXEC2_NAME)

build:
	$(CC) $(CFLAGS) -o $(EXEC1_NAME) day6.c
	$(CC) $(CFLAGS) -o $(EXEC2_NAME) day6part2.c

clean:
	rm -f $(EXEC1_NAME) $(EXEC2_NAME)
