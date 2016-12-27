function debug(str)
    if false then print(str) end
end

function place_letter_at(pos, letter, str)
    return ("%s%s%s"):format(str:sub(1, pos -1), letter, str:sub(pos+1))
end

function swap_position(x,y,str)
    debug("  swap_position: " .. x .. ", " .. y .. ", " .. str)
    local at_x = string.char(str:byte(x))
    local at_y= string.char(str:byte(y))
    local v1 = place_letter_at(y, at_x, str)
    return place_letter_at(x, at_y, v1)
end

debug("SWAP POSITION: should be \"APBLOPABLO\": " .. swap_position(1, 2, "PABLOPABLO"))
debug("SWAP POSITION: should be \"PABLBPAOLO\": " .. swap_position(5, 8, "PABLOPABLO"))

function swap_letter(a,b,str)
    debug("  swap_letter: " .. a .. ", " .. b .. ", " .. str)
    local fst = str:find(a)
    local snd = str:find(b)
    return swap_position(fst, snd, str)
end

debug("SWAP LETTER: should be \"DSAFJKL\": " .. swap_letter("A", "D", "ASDFJKL"))
debug("SWAP LETTER: should be \"QWERPKOF\": " .. swap_letter("P", "F", "QWERFKOP"))

function rotate(direction, magnitude, str)
    debug("  rotate: " .. direction .. ", " .. magnitude .. ", " .. str)
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

debug("ROTATE: should be \"BLOPABLOPA\": " .. rotate("left", 2, "PABLOPABLO"))
debug("ROTATE: should be \"ABLOPABLOP\": " .. rotate("right", 4, "PABLOPABLO"))


function rotate_based_on_letter(letter, str)
    debug("  rotate (letter): " .. letter .. ", " .. str)
    local pos = str:find(letter) - 1
    if pos >= 4 then
        pos = pos + 1
    end
    return rotate("right", pos + 1, str)
end

debug("ROTATE (letter): should be \"ECABD\": " .. rotate_based_on_letter("B", "ABDEC"))
debug("ROTATE (letter): should be \"DECAB\": " .. rotate_based_on_letter("D", "ECABD"))

function inverse_rotate_on_letter(letter, str)
    --[[ This is done the silliest way possible. I ran through all combinations up to 8
    --   letters, and am just doing a reverse mapping.
    ]]--
    local pos = str:find(letter)
    if pos == 1 then return rotate("left", 1, str)
    elseif pos == 2 then return rotate("left", 1, str)
    elseif pos == 3 then return rotate("left", 6, str)
    elseif pos == 4 then return rotate("left", 2, str)
    elseif pos == 5 then return rotate("left", 7, str)
    elseif pos == 6 then return rotate("left", 3, str)
    elseif pos == 7 then return str
    elseif pos == 8 then return rotate("left", 4, str)
    end
end

debug("---ROTATES")
debug("A " .. rotate_based_on_letter("A", "A_______"))
debug("A " .. rotate_based_on_letter("A", "_A______"))
debug("A " .. rotate_based_on_letter("A", "__A_____"))
debug("A " .. rotate_based_on_letter("A", "___A____"))
debug("A " .. rotate_based_on_letter("A", "____A___"))
debug("A " .. rotate_based_on_letter("A", "_____A__"))
debug("A " .. rotate_based_on_letter("A", "______A_"))
debug("A " .. rotate_based_on_letter("A", "_______A"))
debug("---INVERSE")
debug("A " .. inverse_rotate_on_letter("A", "_A______"))
debug("A " .. inverse_rotate_on_letter("A", "___A____"))
debug("A " .. inverse_rotate_on_letter("A", "_____A__"))
debug("A " .. inverse_rotate_on_letter("A", "_______A"))
debug("A " .. inverse_rotate_on_letter("A", "__A_____"))
debug("A " .. inverse_rotate_on_letter("A", "____A___"))
debug("A " .. inverse_rotate_on_letter("A", "______A_"))
debug("A " .. inverse_rotate_on_letter("A", "A_______"))

function reverse(x,y,str)
    debug("  reverse: " .. x .. ", " .. y .. ", " .. str)
    local prefix = str:sub(1, x - 1)
    local to_reverse = str:sub(x,y)
    local suffix = str:sub(y + 1)
    return prefix .. to_reverse:reverse() .. suffix
end

debug("REVERSE: should be \"PABAPOLBLO\": " .. reverse(3, 8, "PABLOPABLO"))
debug("REVERSE: should be \"EMACS\": " .. reverse(1, 5, "SCAME"))

function move(x,y,str)
    debug("  move: " .. x .. ", " .. y .. ", " .. str)
    local at_x = string.char(str:byte(x))
    local v1 = str:gsub(at_x, "")
    local prefix = v1:sub(1, y - 1)
    local rest = v1:sub(y)
    return prefix .. at_x .. rest
end

debug("MOVE: should be \"POABL\": " .. move(5, 2, "PABLO"))
debug("MOVE: should be \"MAECS\": " .. move(1, 3, "EMACS"))
debug("MOVE: should be \"AEMCS\": " .. move(3, 1, "EMACS"))

function luaed(x)
    return tonumber(x) + 1
end

function flip_dir(dir)
    if dir == "left" then return "right" else return "left" end
end

function do_operation(str, op, is_inverse)
    local x, y = op:match("swap position (%d+) with position (%d+)")
    if x then return swap_position(luaed(x), luaed(y), str) end

    local a, b = op:match("swap letter (%a) with letter (%a)")
    if a then return swap_letter(a, b, str) end

    local dir, mag = op:match("rotate (%a+) (%d+) steps?")
    if dir then
        if is_inverse then dir = flip_dir(dir) end
        return rotate(dir, tonumber(mag), str)
    end

    local letter = op:match("rotate based on position of letter (%a)")
    if letter then
        if is_inverse then return inverse_rotate_on_letter(letter, str) end
        return rotate_based_on_letter(letter, str)
    end

    local x, y = op:match("reverse positions (%d+) through (%d+)")
    if x then return reverse(luaed(x), luaed(y), str) end

    local x, y = op:match("move position (%d+) to position (%d+)")
    if x then
        if is_inverse then
            local tmp = x
            x = y
            y = tmp
        end
        return move(luaed(x), luaed(y), str)
    end

    print("NOTHING MATCHED")
    return
end


print("------------")
file_handle = io.open("input.txt")
instructions = {}
for line in file_handle:lines() do
    table.insert(instructions, line)
end
file_handle:close()

input = "abcdefgh"
for i = 1, #instructions, 1 do
    local op = instructions[i]
    input = do_operation(input, op, false)
end

print("Part 1: " .. input)

part2_input = "fbgdceah"
for i = #instructions, 1, -1 do
    local op = instructions[i]
    part2_input = do_operation(part2_input, op, true)
end

print("Part 2: " .. part2_input)
