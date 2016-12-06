! First Factor program lol

USING: combinators io strings math kernel sequences math.parser
       io.encodings.utf8 io.files ;
IN: keypad-nav 

! Converts a row/col index to a number on a keypad. Assumes 0-based indexing for
! both row and column.
: to-keypad ( col row -- numb ) 3 * 1 + + ;

: max-2 ( x -- x ) dup 2 > [ drop 2 ] [ ] if ;
: min-0 ( x -- x ) dup 0 < [ drop 0 ] [ ] if ;

! Checks the letter, alters the ROW/COL as necessary
: process-letter ( row col letter -- row col ) {
    { [ dup CHAR: U = ] [ drop 1 - min-0 ]                }
    { [ dup CHAR: L = ] [ drop swap 1 - min-0 swap ]      }
    { [ dup CHAR: R = ] [ drop swap 1 + max-2 swap ]      }
    { [ dup CHAR: D = ] [ drop 1 + max-2 ]                }
    } cond ;

! Runs around the keypad per the instructions in the line, leaves the ROW/COL
! of the "cursor" where it needs to be.
: process-line ( line col row -- new_col new_row ) [ process-letter ] each ;
    
! Reads the file at the parameterized name and pushes an array of text lines
: read-input-file ( -- x ) "input.txt" utf8 file-lines ;

! Read the input file, then for each row:
!   Set a base case of Row 1, Col 1 (5 in the keypad) on the stack,
!   Convert it to a keypad number
! Then print the list of numbers followed by a newline.
  read-input-file
  [ 1 swap 1 swap process-line to-keypad ] map
  [ number>string write ] each
  "\n" write flush 
