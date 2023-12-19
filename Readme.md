# Program 4 - Assembly Encoder

### CS 261

### Elijah Delavar

### 5/6/2023

## Execution

To compile:

	$ make

To run:

    $ make run

OR

    $ ./encoder

## Description

This program encodes a string using a shift, then decodes the string.  Every character (a-z) in an even position in the string is shifted down in ASCII value.  Every character (a-z) in an odd position in the string is shifted up in ASCII value.  There is a wrap so that the characters being shifted stay within the lowercase alphabet.  ASCII character outside of the a-z range are ignored.  EXAMPLE: "hello" shifted once is "gfkmn".
