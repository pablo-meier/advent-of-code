# Day 1

## Problem description

> You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near",
> unfortunately, is as close as you can get - the instructions on the Easter Bunny
> Recruiting Document the Elves intercepted start here, and nobody had time to
> work them out further.
> 
> The Document indicates that you should start at the given coordinates (where you
> just landed) and face North. Then, follow the provided sequence: either turn
> left (L) or right (R) 90 degrees, then walk forward the given number of blocks,
> ending at a new intersection.
> 
> There's no time to follow such ridiculous instructions on foot, though, so you
> take a moment and work out the destination. Given that you can only walk on the
> street grid of the city, how far is the shortest path to the destination?
> 
> For example:
> - Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
> - R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2
> blocks away.
> - R5, L5, R5, R3 leaves you 12 blocks away.
>
> How many blocks away is Easter Bunny HQ?

## Solution

## How to run

Make sure you have [SMLNJ][1] installed on your machine. Note that

`brew install mlton`

works. Then

`make` && `make run`

## Details

### Part 1

There are two parts of this: find out where you are compared to origin, then
compute the fastest path there.

The first is pretty simple: parse the input, and keep track of current [x,y] as
you traverse. Then sum the absolute values.

I'll use SML since it's a basic problem and I missed it. Big ups to [this
comrade][2] for going over how to even compile the damn language.

### Part 2

Now I have to keep track of where I've been. That's not hard: I'll just pass
another param in track which locations I've visited, and see if I've visited
any before. I won't be doing this particularly efficiently…

   [1]: http://www.smlnj.org/
   [2]: https://thebreakfastpost.com/2015/06/10/standard-ml-and-how-im-compiling-it/
