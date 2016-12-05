
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
sum = File.readlines("input.txt").map { |l| code_from_line(l) }.find_all{ |c| c.is_valid? }.reduce(0) { |sum, code| sum + code.id }
puts(sum)
