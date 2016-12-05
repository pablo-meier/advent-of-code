
CHAR_MAP = {
  "A" => 1, "B" => 2, "C" => 3, "D" => 4, "E" => 5, "F" => 6, "G" => 7,
  "H" => 8, "I" => 9, "J" => 10, "K" => 11, "L" => 12, "M" => 13, "N" => 14,
  "O" => 15, "P" => 16, "Q" => 17, "R" => 18, "S" => 19, "T" => 20, "U" => 21,
  "V" => 22, "W" => 23, "X" => 24, "Y" => 25, "Z" => 0 }

NUM_MAP = {
  1 => "A", 2 => "B", 3 => "C", 4 => "D", 5 => "E", 6 => "F", 7 => "G",
  8 => "H", 9 => "I", 10 => "J", 11 => "K", 12 => "L", 13 => "M", 14 => "N",
  15 => "O", 16 => "P", 17 => "Q", 18 => "R", 19 => "S", 20 => "T", 21 => "U",
  22 => "V", 23 => "W", 24 => "X", 25 => "Y", 0 => "Z" }

class Code
    attr_accessor :name, :id, :checksum
    def initialize(name, id, checksum)
        @name = name
        @id = id
        @checksum = checksum
    end

    def is_valid?
        # Determines if this is a valid Code per the rules in the problem
        # statement
        checksum = self.make_checksum()
        checksum == @checksum
    end

    def to_s()
        "Name: #{@name}, ID #{@id.to_s}, checksum #{@checksum}"
    end

    def make_decrypted
        new_str = ""
        @name.each_char do |c|
            if c == "-"
                new_str << " "
                next
            end
            val = CHAR_MAP[c.upcase]
            new_val = (val + @id) % 26
            new_str << NUM_MAP[new_val]
        end
        new_str
    end

    def make_checksum()
        char_hash = {}
        @name.each_char do |c|
            if c == "-" then next end
            if char_hash.has_key?(c)
                char_hash[c] = char_hash[c] + 1
            else
                char_hash[c] = 1
            end
        end
        as_array = char_hash.to_a
        by_magnitude = {}
        as_array.each do |val|
            if by_magnitude.has_key?(val[1])
                by_magnitude[val[1]] << val[0]
            else
                by_magnitude[val[1]] = [val[0]]
            end
        end
        as_array = by_magnitude.to_a
        as_array.map { |elem| elem[1].sort! }
        as_array.sort { |x,y| y[0] <=> x[0] }.map do |elem|
            elem[1]
        end.flatten()[0..4].join("")
    end
end


CODE_REGEX = /([a-z-]+)([0-9]+)\[([a-z]+)\]/
def code_from_line(line)
    matchdata = line.match(CODE_REGEX)
    name = matchdata[1]
    id = matchdata[2].to_i
    checksum = matchdata[3]
    Code.new(name, id, checksum)
end


# I'm terrible
File.readlines("input.txt").map { |l| code_from_line(l) }.each do |code|
    puts(code.to_s)
    puts("  #{code.make_decrypted} - #{code.id}")
end
