class Computer
  def initialize(data_str)
    @data = data_str.split(',').map(&:to_i)
    @pc = 0
    @inputs = []
    @outputs = []
  end

  def run
    loop do
      code = command
      case code[0]
      when 1
        add(code)
        self.pc = pc + 4
      when 2
        multiply(code)
        self.pc = pc + 4
      when 3
        input
        self.pc = pc + 2
      when 4
        output
        self.pc = pc + 2
        break
      when 5
        jump_if_true(code)
      when 6
        jump_if_false(code)
      when 7
        less_than(code)
        self.pc = pc + 4
      when 8
        equals(code)
        self.pc = pc + 4
      else
        @halted = true
        break
      end
    end
  end

  def halted?
    @halted
  end

  attr_reader :outputs
  attr_accessor :inputs

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

  def value(offset, modes)
    addr = data[pc + offset]
    modes[offset].zero? ? data[addr] : addr
  end

  def add(modes)
    dest = data[pc + 3]
    data[dest] = value(1, modes) + value(2, modes)
  end

  def multiply(modes)
    dest = data[pc + 3]
    data[dest] = value(1, modes) * value(2, modes)
  end

  def input
    #puts 'input >'
    dest = data[pc + 1]
    value = @inputs.shift || gets.to_i
    data[dest] = value
  end

  def output
    addr1 = data[pc + 1]
    value = data[addr1]
    @outputs = [value]
    #puts "value at #{addr1} = #{value}"
  end

  def jump_if_true(modes)
    self.pc = value(1, modes).zero? ? pc + 3 : value(2, modes)
  end

  def jump_if_false(modes)
    self.pc = value(1, modes).zero? ? value(2, modes) : pc + 3
  end

  def less_than(modes)
    dest = data[pc + 3]
    data[dest] = value(1, modes) < value(2, modes) ? 1 : 0
  end

  def equals(modes)
    dest = data[pc + 3]
    data[dest] = value(1, modes) == value(2, modes) ? 1 : 0
  end
end

program = File.read('2019/2019-07.data')

max = 0
(5..9).to_a.permutation(5).each do |phases|
  input = 0
  computers = []
  phases.each do |phase|
    computer = Computer.new(program)
    computers << computer
    computer.inputs = [phase, input]
    computer.run
    input = computer.outputs.first
  end
  until computers[4].halted?
    computers.each do |computer|
      computer.inputs = [input]
      computer.run
      input = computer.outputs.first
    end
  end
  max = input > max ? input : max
end
puts max
