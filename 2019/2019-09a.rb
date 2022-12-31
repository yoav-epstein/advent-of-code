class Computer
  def initialize(data_str)
    @data = data_str.split(',').map(&:to_i)
    @pc = 0
    @inputs = []
    @outputs = []
    @relative = 0
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
        input(code)
        self.pc = pc + 2
      when 4
        output(code)
        self.pc = pc + 2
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
      when 9
        adjust_relative(code)
        self.pc = pc + 2
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
  attr_accessor :pc, :relative

  def command
    code = data[pc]
    opcode = code % 100
    modes = code / 100
    modes.to_s.reverse.chars.map(&:to_i)
    [opcode, *modes.to_s.reverse.chars.map(&:to_i), 0, 0]
  end

  def value(offset, modes)
    addr = data[pc + offset]
    case modes[offset]
    when 0
      data[addr] || 0
    when 1
      addr
    else
      data[relative + addr] || 0
    end
  end

  def add(modes)
    dest = data[pc + 3]
    dest += relative if modes[3] == 2
    data[dest] = value(1, modes) + value(2, modes)
  end

  def multiply(modes)
    dest = data[pc + 3]
    dest += relative if modes[3] == 2
    data[dest] = value(1, modes) * value(2, modes)
  end

  def input(modes)
    #puts 'input >'
    dest = data[pc + 1]
    dest += relative if modes[1] == 2
    value = @inputs.shift || gets.to_i
    data[dest] = value
  end

  def output(modes)
    @outputs << value(1, modes)
  end

  def jump_if_true(modes)
    self.pc = value(1, modes).zero? ? pc + 3 : value(2, modes)
  end

  def jump_if_false(modes)
    self.pc = value(1, modes).zero? ? value(2, modes) : pc + 3
  end

  def less_than(modes)
    dest = data[pc + 3]
    dest += relative if modes[3] == 2
    data[dest] = value(1, modes) < value(2, modes) ? 1 : 0
  end

  def equals(modes)
    dest = data[pc + 3]
    dest += relative if modes[3] == 2
    data[dest] = value(1, modes) == value(2, modes) ? 1 : 0
  end

  def adjust_relative(modes)
    self.relative = relative + value(1, modes)
  end
end

program = File.read('2019/2019-09.data')

computer = Computer.new(program)
computer.inputs = [1]
computer.run
puts computer.outputs.inspect
