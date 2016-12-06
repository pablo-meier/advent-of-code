# Day 6

## Problem description

> Something is jamming your communications with Santa. Fortunately, your signal is
> only partially jammed, and protocol in situations like this is to switch to a
> simple repetition code to get the message through.
> 
> In this model, the same message is sent repeatedly. You've recorded the
> repeating message signal (your puzzle input), but the data seems quite corrupted
> - almost too badly to recover. Almost.
> 
> All you need to do is figure out which character is most frequent for each
> position. For example, suppose you had recorded the following messages:
> 
> ```
> eedadn
> drvtee
> eandsr
> raavrd
> atevrs
> tsrnev
> sdttsa
> rasrtv
> nssdts
> ntnada
> svetve
> tesnvt
> vntsnd
> vrdear
> dvrsen
> enarar
> ```
> 
> The most common character in the first column
> is e; in the second, a; in the third, s, and so on. Combining these characters
> returns the error-corrected message, easter.
> 
> Given the recording in your puzzle input, what is the error-corrected version of
> the message being sent?

## Solution

## How to run

Make sure you have [clang][1] installed on your machine (though gcc would
probably work too). Then:

`make`

## Details

### Part 1

Hey, I get to use C! This is pretty trivial: allocate five buffers of 26, one
for each column, then for every line, keep frequency count. Count highest one
at the end of the file.

### Part 2

Flip a single character and change a `>` to a `<`. C'mon mang.

Sad I didn't really get back into the `malloc`/`free` game.

  [1]: http://clang.llvm.org/
