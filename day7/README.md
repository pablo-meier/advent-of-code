# Day 7

## Problem description

> While snooping around the local network of EBHQ, you compile a list of IP
> addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to
> figure out which IPs support TLS (transport-layer snooping).
> 
> An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA.
> An ABBA is any four-character sequence which consists of a pair of two
> different characters followed by the reverse of that pair, such as xyyx or
> abba. However, the IP also must not have an ABBA within any hypernet sequences,
> which are contained by square brackets.
> 
> For example:
> 
> * `abba[mnop]qrst` supports TLS (abba outside square brackets).
> * `abcd[bddb]xyyx` does not support TLS (bddb is within square brackets, even
>    though `xyyx` is outside square brackets).
> * `aaaa[qwer]tyui` does not support TLS (`aaaa` is invalid; the interior
>   characters must be different).
> * `ioxxoj[asdfgh]zxcvbn` supports TLS (oxxo is outside square brackets, even
>   though it's within a larger string).
> 
> How many IPs in your puzzle input support TLS?

## Solution

## How to run

Make sure you have [SWI Prolog][1] installed on your machine. Then:

`make`

## Details

### Part 1

Pretty straightforward: open a file, line by line, count the number of true lines
for a predicate that supports TLS. Besides file IO and regexes being tricky in
Prolog, the hardest part will be getting the right conditional logic (i.e. in
brackets means it's an instant False, for example).

### Part 2

LOL this got harder since we're tracking matching 3-char sequences. But I think
I can do it with conditional logic on `inside`/`outside` to store/access a growable
list of matching 3-char sequences.


  [1]: http://www.swi-prolog.org/
