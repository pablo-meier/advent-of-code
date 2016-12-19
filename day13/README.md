# Day 13

## Problem description

> You arrive at the first floor of this new building to discover a much less
> welcoming environment than the shiny atrium of the last one. Instead, you are
> in a maze of twisty little cubicles, all alike.
> 
> Every location in this area is addressed by a pair of non-negative integers
> (x,y). Each such coordinate is either a wall or an open space. You can't move
> diagonally. The cube maze starts at 0,0 and seems to extend infinitely toward
> positive x and y; negative values are invalid, as they represent a location
> outside the building. You are in a small waiting area at 1,1.
> 
> While it seems chaotic, a nearby morale-boosting poster explains, the layout is
> actually quite logical. You can determine whether a given x,y coordinate will
> be a wall or an open space using a simple system:
> 
> * Find `x*x + 3*x + 2*x*y + y + y*y`.
> 
> * Add the office designer's favorite number (your puzzle input).
> 
> * Find the binary representation of that sum; count the number of bits that are 1.
> 
> * If the number of bits that are 1 is even, it's an open space.
> 
> * If the number of bits that are 1 is odd, it's a wall.
> 
> For example, if the office designer's favorite number were 10, drawing walls as
> `#` and open spaces as `.`, the corner of the building containing 0,0 would look
> like this:
> 
> ```
>   0123456789
> 0 .#.####.##
> 1 ..#..#...#
> 2 #....##...
> 3 ###.#.###.
> 4 .##..#..#.
> 5 ..##....#.
> 6 #...##.###
> ```
> 
> Now, suppose you wanted to reach 7,4. The shortest route you could take is marked as O:
> 
> ```
>   0123456789
> 0 .#.####.##
> 1 .O#..#...#
> 2 #OOO.##...
> 3 ###O#.###.
> 4 .##OO#OO#.
> 5 ..##OOO.#.
> 6 #...##.###
> ```
> 
> Thus, reaching 7,4 would take a minimum of 11 steps (starting from your current
> location, 1,1).
> 
> What is the fewest number of steps required for you to reach 31,39?

## Solution

## How to run

Get Python 3 going and in your path as `python`. ([virtualenv][1] might help).
Then

`make`

Python sucks.

## Part 1

Alright, we've got a few things going here. There might be a clever way to
circumvent some of these steps but I don't happen to know them…

* First you gotta write a "is open or wall" function. Luckily, from the steps
  above, it looks only linear time to the number of digits the first equation
  outputs, which isn't HUGE, so I don't expect it'll be too much effort to
  detect these things.

* From _that_, you can run a shortest path (Dijkstra or A* would work) to
  find the minimum path, using the above function to detect walls.

## Part 2

Add a step counter and barf when you hit the number of steps. Since we're on
a PQ with a target, I'll move the target out of bounds so it'll try absolutely
everything.

   [1]: https://virtualenv.pypa.io/en/stable/
