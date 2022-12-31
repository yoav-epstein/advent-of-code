class Computer
  def initialize
    input = File.read('2021/2021-16.data')

    @chars = input.chomp.each_char
  end

  def call
    @commands = []
    @code = []
    @bit_count = 0
    loop.map do
      parse_command
    end
  end

  private

  attr_reader :chars, :commands, :code, :bit_count

  def next_bin
    c = chars.next
    binary = c.to_i(16).to_s(2).chars
    ['0', '0', '0', *binary].last(4)
  end

  def take_bits(count)
    @code += next_bin while code.size < count
    @bit_count += count
    code.shift(count).join.to_i(2)
  end

  def parse_command
    version = take_bits(3)
    type = take_bits(3)
    puts "type = #{type}"
    literal_command(version, type) || operator_command(version, type)
  end

  def literal_command(version, type)
    return unless type == 4

    value = 0
    loop do
      prefix = take_bits(1)
      sub_value = take_bits(4)
      value = value * 16 + sub_value
      break if prefix == 0
    end

    { version: version, type: type, value: value }
  end

  def operator_command(version, type)
    length_type = take_bits(1)

    if length_type == 0
      sub_packets = length_in_bits_subpackets
    else
      sub_packets = number_of_subpackets
    end

    values = sub_packets.map { |packet| packet[:value] }

    value = case type
            when 0
              values.sum
            when 1
              values.reduce(:*)
            when 2
              values.min
            when 3
              values.max
            when 5
              values[0] > values[1] ? 1 : 0
            when 6
              values[0] < values[1] ? 1 : 0
            when 7
              values[0] == values[1] ? 1 : 0
            end

    { version: version, type: type, value: value }
  end

  def length_in_bits_subpackets
    length = take_bits(15) + bit_count
    sub_packets = []
    sub_packets << parse_command while bit_count < length
    sub_packets
  end

  def number_of_subpackets
    num_packets = take_bits(11)
    num_packets.times.map { parse_command }
  end
end

p Computer.new.call
