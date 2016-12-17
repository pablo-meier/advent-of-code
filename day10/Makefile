# We back in Makefileland, kids.

CC=clang++
CFLAGS=-Iinclude -std=c++11 -Wall -Werror -O3
EXEC=botty_bots
BUILD=build

run: build
	./$(BUILD)/$(EXEC) --part1
	./$(BUILD)/$(EXEC) --part2

build: prepare
	$(CC) $(CFLAGS) -c -o $(BUILD)/bot.o src/bot.cpp
	$(CC) $(CFLAGS) -c -o $(BUILD)/instructions.o src/instructions.cpp
	$(CC) $(CFLAGS) -c -o $(BUILD)/fileparser.o src/fileparser.cpp
	$(CC) $(CFLAGS) -o $(BUILD)/$(EXEC) src/main.cpp $(BUILD)/bot.o $(BUILD)/instructions.o $(BUILD)/fileparser.o

prepare:
	[ -d $(BUILD) ] || mkdir $(BUILD)

clean:
	rm -rf $(BUILD)
