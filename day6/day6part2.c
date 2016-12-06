#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>


int main(int argc, char** argv)
{
	uint8_t NUM_LETTERS = 8;
	uint8_t ALPHABET_SIZE = 26;
	uint16_t MAX_OCCURRENCES = 1000;
	
	uint8_t ASCII_OFFSET = 97;
	
	uint16_t arrays_of_chars[NUM_LETTERS][ALPHABET_SIZE];
	memset(arrays_of_chars, 0, sizeof(char[0][0]) * NUM_LETTERS * ALPHABET_SIZE);
	
	FILE* fp;
	char buffer[255];
	fp = fopen("input.txt", "r");
	while(fgets(buffer, 255, (FILE*) fp)) {
		for (uint8_t i = 0; i < NUM_LETTERS; ++i) {
			uint8_t letter_index = (buffer[i]) - ASCII_OFFSET;
			++(arrays_of_chars[i][letter_index]);
		}
	}
	fclose(fp);
	
	for (uint8_t i = 0; i < NUM_LETTERS; ++i) {
		uint16_t curr_min = MAX_OCCURRENCES;
		char curr_char = '\0';
		for (uint8_t j = 0; j < ALPHABET_SIZE; ++j) {
			if (arrays_of_chars[i][j] < curr_min) {
				curr_min = arrays_of_chars[i][j];
				curr_char = (j + ASCII_OFFSET);
			}
		}
		printf("%c", curr_char);
	}
	printf("\n");
}
