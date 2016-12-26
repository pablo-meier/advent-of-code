
function place_letter_at(pos, letter, str)
    return ("%s%s%s"):format(str:sub(1, pos -1), letter, str:sub(pos+1))
end

function swap_position(x,y,str)
    print("  swap_position: " .. x .. ", " .. y .. ", " .. str)
    local at_x = string.char(str:byte(x))
    local at_y= string.char(str:byte(y))
    local v1 = place_letter_at(y, at_x, str)
    return place_letter_at(x, at_y, v1)
end

print("SWAP POSITION: should be \"APBLOPABLO\": " .. swap_position(1, 2, "PABLOPABLO"))
print("SWAP POSITION: should be \"PABLBPAOLO\": " .. swap_position(5, 8, "PABLOPABLO"))

function swap_letter(a,b,str)
    print("  swap_letter: " .. a .. ", " .. b .. ", " .. str)
    local fst = str:find(a)
    local snd = str:find(b)
    return swap_position(fst, snd, str)
end

print("SWAP LETTER: should be \"DSAFJKL\": " .. swap_letter("A", "D", "ASDFJKL"))
print("SWAP LETTER: should be \"QWERPKOF\": " .. swap_letter("P", "F", "QWERFKOP"))

function rotate(direction, magnitude, str)
    print("  rotate: " .. direction .. ", " .. magnitude .. ", " .. str)
    local mag = magnitude % str:len()
    if mag == 0 then return str end
    if direction == "left" then
        local prefix = str:sub(1, mag)
        local rest = str:sub(mag + 1)
        return rest .. prefix
    else
        local suffix = str:sub(-mag)
        local rest = str:sub(1, str:len() - mag)
        return suffix .. rest
    end
end

print("ROTATE: should be \"BLOPABLOPA\": " .. rotate("left", 2, "PABLOPABLO"))
print("ROTATE: should be \"ABLOPABLOP\": " .. rotate("right", 4, "PABLOPABLO"))


function rotate_based_on_letter(letter, str)
    print("  rotate (letter): " .. letter .. ", " .. str)
    local pos = str:find(letter) - 1
    if pos >= 4 then
        pos = pos + 1
    end
    return rotate("right", pos + 1, str)
end

print("ROTATE (letter): should be \"ECABD\": " .. rotate_based_on_letter("B", "ABDEC"))
print("ROTATE (letter): should be \"DECAB\": " .. rotate_based_on_letter("D", "ECABD"))


function reverse(x,y,str)
    print("  reverse: " .. x .. ", " .. y .. ", " .. str)
    local prefix = str:sub(1, x - 1)
    local to_reverse = str:sub(x,y)
    local suffix = str:sub(y + 1)
    return prefix .. to_reverse:reverse() .. suffix
end

print("REVERSE: should be \"PABAPOLBLO\": " .. reverse(3, 8, "PABLOPABLO"))
print("REVERSE: should be \"EMACS\": " .. reverse(1, 5, "SCAME"))

function move(x,y,str)
    print("  move: " .. x .. ", " .. y .. ", " .. str)
    local at_x = string.char(str:byte(x))
    local v1 = str:gsub(at_x, "")
    local prefix = v1:sub(1, y - 1)
    local rest = v1:sub(y)
    return prefix .. at_x .. rest
end

print("MOVE: should be \"POABL\": " .. move(5, 2, "PABLO"))
print("MOVE: should be \"MAECS\": " .. move(1, 3, "EMACS"))
print("MOVE: should be \"AEMCS\": " .. move(3, 1, "EMACS"))

function luaed(x)
    return tonumber(x) + 1
end

function do_operation(str, op)
    local x, y = op:match("swap position (%d+) with position (%d+)")
    if x then return swap_position(luaed(x), luaed(y), str) end

    local a, b = op:match("swap letter (%a) with letter (%a)")
    if a then return swap_letter(a, b, str) end

    local dir, mag = op:match("rotate (%a+) (%d+) steps?")
    if dir then return rotate(dir, tonumber(mag), str) end

    local letter = op:match("rotate based on position of letter (%a)")
    if letter then return rotate_based_on_letter(letter, str) end

    local x, y = op:match("reverse positions (%d+) through (%d+)")
    if x then return reverse(luaed(x), luaed(y), str) end

    local x, y = op:match("move position (%d+) to position (%d+)")
    if x then return move(luaed(x), luaed(y), str) end

    print("NOTHING MATCHED")
    return
end


print("------------")
input = "abcdefgh"
file_handle = io.open("input.txt")
while true do
    line = file_handle:read()
    if line == nil then break end
    input = do_operation(input, line)
    print("        INPUT: " .. input)
end

file_handle:close()
