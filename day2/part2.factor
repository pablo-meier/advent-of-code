! SECOND Factor program lolololol
! Main differences between this and the first one:
!  * We need to persist state of location across rows (previous program merely
!    started at center)
!  * Navigation/border logic significantly harder.
!
! Will use sequences properly for locations, rather than naked row/cols

USING: combinators io strings math kernel sequences math.parser
       io.encodings.utf8 io.files ;
IN: keypad-nav 

: row ( seq -- seq first ) dup first ;
: col ( seq -- seq second ) dup second ;

: set-row ( seq val -- seq ) over set-first ;
: set-col ( seq val -- seq ) over set-second ;

: is-one   ( loc -- loc bool ) dup col 2 = swap row 0 = swap drop and ;
: is-two   ( loc -- loc bool ) dup col 1 = swap row 1 = swap drop and ;
: is-three ( loc -- loc bool ) dup col 2 = swap row 1 = swap drop and ;
: is-four  ( loc -- loc bool ) dup col 3 = swap row 1 = swap drop and ;
: is-five  ( loc -- loc bool ) dup col 0 = swap row 2 = swap drop and ; 
: is-six   ( loc -- loc bool ) dup col 1 = swap row 2 = swap drop and ; 
: is-seven ( loc -- loc bool ) dup col 2 = swap row 2 = swap drop and ;
: is-eight ( loc -- loc bool ) dup col 3 = swap row 2 = swap drop and ;
: is-nine  ( loc -- loc bool ) dup col 4 = swap row 2 = swap drop and ;
: is-a     ( loc -- loc bool ) dup col 1 = swap row 3 = swap drop and ;
: is-b     ( loc -- loc bool ) dup col 2 = swap row 3 = swap drop and ; 
: is-c     ( loc -- loc bool ) dup col 3 = swap row 3 = swap drop and ; 
: is-d     ( loc -- loc bool ) dup col 2 = swap row 4 = swap drop and ; 

! Converts a row/col index to a number on a keypad. Assumes 0-based indexing for
! both row and column. This is silly, but one way to build a wall!
: to-keypad ( loc -- loc ) {
    { [ is-one ] [ "1" ] }
    { [ is-two ] [ "2" ] }
    { [ is-three ] [ "3" ] }
    { [ is-four ] [ "4" ] }
    { [ is-five ] [ "5" ] }
    { [ is-six ] [ "6" ] }
    { [ is-seven ] [ "7" ] }
    { [ is-eight ] [ "8" ] }
    { [ is-nine ] [ "9" ] }
    { [ is-a ] [ "A" ] }
    { [ is-b ] [ "B" ] }
    { [ is-c ] [ "C" ] }
    { [ is-d ] [ "D" ] }
    } cond
    write ;

: cant-go-top? ( loc -- loc bool ) is-five swap is-two swap is-one swap is-four swap is-nine rot or rot or rot or rot or ;
: cant-go-left? ( loc -- loc bool ) is-one swap is-two swap is-five swap is-a swap is-d rot or rot or rot or rot or ;
: cant-go-right? ( loc -- loc bool ) is-one swap is-four swap is-nine swap is-c swap is-d rot or rot or rot or rot or ;
: cant-go-down? ( loc -- loc bool ) is-five swap is-a swap is-d swap is-c swap is-nine rot or rot or rot or rot or ;

! Checks the letter, alters the ROW/COL as necessary
: process-letter ( loc letter -- loc ) {
    { [ dup CHAR: U = ] [ 
        drop
        { { [ cant-go-top? ] [ ] }
          [ row 1 - set-row ] 
        } cond ] }
    { [ dup CHAR: L = ] [ 
        drop
        { { [ cant-go-left? ] [ ] }
          [ col 1 - set-col ]
        } cond ] }
    { [ dup CHAR: R = ] [
        drop
        { { [ cant-go-right? ] [ ] }
          [ col 1 + set-col ]
        } cond ] }
    { [ dup CHAR: D = ] [
        drop
        { { [ cant-go-down? ] [ ] }
        [ row 1 + set-row ]
        } cond ] }
    } cond ;

! Runs around the keypad per the instructions in the line, leaves the ROW/COL
! of the "cursor" where it needs to be.
: process-line ( loc line -- loc ) [ process-letter ] each ;
    
! Reads the file at the parameterized name and pushes an array of text lines
: read-input-file ( -- x ) "input.txt" utf8 file-lines ;

! Read the input file, then for each row:
!   Set a base case (5 in the keypad) on the stack,
!   Convert it to a keypad number
! Print-as-you-go, which isn't normally my style, but...

  { 2 0 }
  read-input-file
  [ process-line to-keypad ] each
  drop
  "\n" write flush 
