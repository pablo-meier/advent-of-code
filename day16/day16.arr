fun flip(x):
  if x == 0:
    1
  else:
    0
  end
end

fun fill_data_expand(chars):
  copy = chars.reverse()
  flipped = map(flip, copy)
  chars.append([list: 0]).append(flipped)
end

check:
  fill_data_expand([list: 1]) is [list: 1, 0, 0]
  fill_data_expand([list: 0]) is [list: 0, 0, 1]
  fill_data_expand([list: 1,1,1,1,1]) is [list: 1,1,1,1,1,0,0,0,0,0,0]  
end


fun fill_data(chars, max_length):
  if chars.length() < max_length:
    fill_data(fill_data_expand(chars), max_length)
  else:
    chars.take(max_length)
  end
end

check:
  fill_data([list: 1], 3) is [list: 1, 0, 0]
  fill_data([list: 0], 3) is [list: 0, 0, 1]
  fill_data([list: 1,1,1,1,1], 11) is [list: 1,1,1,1,1,0,0,0,0,0,0]
  fill_data([list: 1,1,1,1,1], 6) is [list: 1,1,1,1,1,0]  
  fill_data([list: 1,0,0,0,0], 20) is [list: 1,0,0,0,0,0,1,1,1,1,0,0,1,0,0,0,0,1,1,1]
end

    
fun pair_shrink(pair):
  if pair.get(0) == pair.get(1):
    1
  else:
    0
  end
end


fun checksum_shrink(digits):
  if is-empty(digits):
    empty
  else:
    split = digits.split-at(2)
    link(pair_shrink(split.prefix), checksum_shrink(split.suffix))
  end
end

check:
  checksum_shrink([list: 0,0]) is [list: 1]
  checksum_shrink([list: 1,1]) is [list: 1]
  checksum_shrink([list: 1,0]) is [list: 0]
  checksum_shrink([list: 0,1]) is [list: 0]
  checksum_shrink([list: 0,1,1,1]) is [list: 0,1]
  checksum_shrink([list: 1,1,0,1]) is [list: 1,0]
  checksum_shrink([list: 1,1,0,0]) is [list: 1,1]
end


fun checksum(digits):
  shrunken = checksum_shrink(digits)
  if num-modulo(shrunken.length(), 2) == 0:
    checksum(shrunken)
  else:
    shrunken
  end
end

check:
  checksum([list: 1,1,0,0,1,0,1,1,0,1,0,0]) is [list: 1,0,0]
  checksum([list: 1,0,0,0,0,0,1,1,1,1,0,0,1,0,0,0,0,1,1,1]) is [list: 0,1,1,0,0]
  checksum([list: 0,1,1,0,0,0,1,1,0,0,1,1,0,1,0,1,1,0,0,1,1,0,0,0,1,1,1,0,1,1,0,1,0,1,1,0,0,1,1,0,0,0,1,1,0,0,1,1,0,1,0,1,1,1,0,1,1,0,0,0,1,1,1,0,1,1,0,1]) is [list: 1,1,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0]
end


fun fill_disk_checksum(initial, size):
  checksum(fill_data(initial, size)).join-str("")
end


check:
  fill_disk_checksum([list: 1,0,0,0,0], 20) is "01100"
end

# Part 1
print("Part 1\n")
print(fill_disk_checksum([list: 0,1,1,1,1,0,0,1,1,0,0,1,1,1,0,1,1], 272))

# Part 2
print("\nPart 2\n")
# fill_disk_checksum(fill_data([list: 0,1,1,1,1,0,0,1,1,0,0,1,1,1,0,1,1], 35651584))
