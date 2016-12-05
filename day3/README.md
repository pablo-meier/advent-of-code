# Day 3

## Problem description

> Now that you can think clearly, you move deeper into the labyrinth of hallways
> and office furniture that makes up this part of Easter Bunny HQ. This must be
> a graphic design department; the walls are covered in specifications for
> triangles.
> 
> Or are they?
> 
> The design document gives the side lengths of each triangle it describes,
> but... 5 10 25? Some of these aren't triangles. You can't help but mark the
> impossible ones.
> 
> In a valid triangle, the sum of any two sides must be larger than the
> remaining side. For example, the "triangle" given above is impossible, because
> 5 + 10 is not larger than 25.
> 
> In your puzzle input, how many of the listed triangles are possible?

## Solution

## How to run

Make sure you have [Racket][1] installed on your machine, with the command
`racket` in your `PATH`, or aliased to its position. Then:

`make`

## Details

### Part 1

Jesus, why couldn't I have had this on the day I wrote Factor?

Keep a counter, and for every line in the program, `inc` if the line satisfies.

HOT SHIT, I know.

### Part 2

Map the lines into a long list, then pick them three at a time. I did it rather
inelegantly (mostly in the `(list* (list ...) (list ...) (list ...) accum)`
bit) but for such a simple case it suffices :D

  [1]: http://racket-lang.org
