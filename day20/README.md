# Day 20

## Problem description

> You'd like to set up a small hidden computer here so you can use it to get back
> into the network later. However, the corporate firewall only allows
> communication with certain external IP addresses.
> 
> You've retrieved the list of blocked IPs from the firewall, but the list seems
> to be messy and poorly maintained, and it's not clear which IPs are allowed.
> Also, rather than being written in dot-decimal notation, they are written as
> plain 32-bit integers, which can have any value from 0 through 4294967295,
> inclusive.
> 
> For example, suppose only the values 0 through 9 were valid, and that you
> retrieved the following blacklist:
> 
> 5-8
> 0-2
> 4-7
> 
> The blacklist specifies ranges of IPs (inclusive of both the start
> and end value) that are not allowed. Then, the only IPs that this firewall
> allows are 3 and 9, since those are the only numbers not in any range.
> 
> Given the list of blocked IPs you retrieved from the firewall (your puzzle
> input), what is the lowest-valued IP that is not blocked?

## Solution

## How to run

Ensure you have [Leinengen][1] installed, then run

`make`

BigInteger/JVM stuff made this more interesting than it had any right to be 😛

## Part 1

EZ, sort the intervals by their starting point, then interate through them until
you see any open space between the end of one and the start of the next.

## Part 2

Almost as EZ, count the difference between the end of an interval and the start
of the next one, remembering to fill in the end of the range, and account of
off-by-ones.

   [1]: http://leiningen.org/
