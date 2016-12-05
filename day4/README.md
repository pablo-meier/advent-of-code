# Day 4

## Problem description

Finally, you come across an information kiosk with a list of rooms. Of course,
the list is encrypted and full of decoy data, but the instructions to decode the
list are barely hidden nearby. Better remove the decoy data first.

Each room consists of an encrypted name (lowercase letters separated by dashes)
followed by a dash, a sector ID, and a checksum in square brackets.

A room is real (not a decoy) if the checksum is the five most common letters in
the encrypted name, in order, with ties broken by alphabetization. For example:

* `aaaaa-bbb-z-y-x-123[abxyz]` is a real room because the most common letters
  are a (5), b (3), and then a tie between x, y, and z, which are listed
  alphabetically.

* `a-b-c-d-e-f-g-h-987[abcde]` is a real room because although the letters are
  all tied (1 of each), the first five are listed alphabetically.
* `not-a-real-room-404[oarel]` is a real room.

* `totally-real-room-200[decoy]` is not.

Of the real rooms from the list above, the sum of their sector IDs is 1514.

What is the sum of the sector IDs of the real rooms?

## Solution

## How to run

Make sure you have [Ruby][1] installed on your machine, with the command
`ruby` in your `PATH`, or aliased to its position. [RVM][2] might be helpful
here. I'm using **MRI 2.3**. Then:

`make`

## Details

### Part 1

It's past midnight so I'm doing this in Ruby, which I have a feeling will still
find a way to bite me in the ass.

* Regex split the line into its three components: name, ID, and checksum.
* Build a map of the name with letter occurrence, skipping dashes.
* Convert to sorted list on two keys: first on frequency, secondarily on letter
  order.
* Traverse map on checksum, ensure it's legit. If so, add ID to running total.

I thought about doing it in C but the letter ordering after the frequency
ordering just seemed like a collosal hassle.

### Part 2

Part 2 oddly seems easier, since you're not doing several sorts. Map on a string
on some modulo math, then print with the sector ID, look for something with north
pole on it.

  [1]: https://www.ruby-lang.org/en/
  [2]: https://rvm.io/
