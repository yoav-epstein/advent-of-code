class Computer
  def initialize(data_str)
    @data = data_str.split(',').map(&:to_i)
    @pc = 0
  end

  def run
    loop do
      code = command
      case code[0]
      when 1
        add(code[1, 2])
        self.pc = pc + 4
      when 2
        multiply(code[1, 2])
        self.pc = pc + 4
      when 3
        input
        self.pc = pc + 2
      when 4
        output
        self.pc = pc + 2
      else
        break
      end
    end
  end

  private

  attr_reader :data
  attr_accessor :pc

  def command
    code = data[pc]
    opcode = code % 100
    modes = code / 100
    modes.to_s.reverse.chars.map(&:to_i)
    [opcode, *modes.to_s.reverse.chars.map(&:to_i), 0, 0]
  end

  def add(modes)
    addr1 = data[pc + 1]
    addr2 = data[pc + 2]
    dest = data[pc + 3]
    value1 = modes[0] == 1 ? addr1 : data[addr1]
    value2 = modes[1] == 1 ? addr2 : data[addr2]
    data[dest] = value1 + value2
  end

  def multiply(modes)
    addr1 = data[pc + 1]
    addr2 = data[pc + 2]
    dest = data[pc + 3]
    value1 = modes[0] == 1 ? addr1 : data[addr1]
    value2 = modes[1] == 1 ? addr2 : data[addr2]
    data[dest] = value1 * value2
  end

  def input
    puts 'input >'
    dest = data[pc + 1]
    value = gets.to_i
    data[dest] = value
  end

  def output
    addr1 = data[pc + 1]
    value = data[addr1]
    puts "value at #{addr1} = #{value}"
  end
end

input = File.read('2019/2019-05.data')

computer = Computer.new(input)
computer.run
