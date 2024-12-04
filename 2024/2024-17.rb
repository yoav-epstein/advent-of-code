require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def computer
    @computer ||= input.readlines.filter_map do |line|
      next if line.chomp.empty?

      line.scan(/\d+/).map(&:to_i)
    end
  end

  private

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class Computer
  def initialize(register_a, register_b, register_c, program)
    @register_a = register_a[0]
    @register_b = register_b[0]
    @register_c = register_c[0]
    @program = program
  end

  def execute
    @output = []
    @instruction_pointer = 0
    while instruction_pointer < program_size
      instruction = program[instruction_pointer]
      operand = program[instruction_pointer + 1]
      @instruction_pointer += 2

      send opcodes[instruction], operand
    end

    output
  end

  private

  attr_reader :program, :output
  attr_accessor :register_a, :register_b, :register_c, :instruction_pointer

  def opcodes
    @opcodes ||= {
      0 => :adv,
      1 => :bxl,
      2 => :bst,
      3 => :jnz,
      4 => :bxc,
      5 => :out,
      6 => :bdv,
      7 => :cdv
    }
  end

  def combo(operand)
    case operand
    when 4
      register_a
    when 5
      register_b
    when 6
      register_c
    when 7
      raise "invalid"
    else
      operand
    end
  end

  def adv(operand)
    @register_a = register_a / 2**combo(operand)
  end

  def bxl(operand)
    @register_b = register_b ^ operand
  end

  def bst(operand)
    @register_b = combo(operand) % 8
  end

  def jnz(operand)
    return if register_a.zero?

    @instruction_pointer = operand
  end

  def bxc(_operand)
    @register_b ^= register_c
  end

  def out(operand)
    output << combo(operand) % 8
  end

  def bdv(operand)
    @register_b = register_a / 2**combo(operand)
  end

  def cdv(operand)
    @register_c = register_a / 2**combo(operand)
  end

  def program_size
    @program_size ||= @program.size
  end
end

class Computer2 < Computer
  class IncorrectOutput < StandardError; end

  # bst 4  b = a % 8
  # bxl 5  b = b ^ 5
  # cdv 5  c = a / 2**b
  # bxl 6  b = b ^ 6
  # bxc 2  b = b ^ c
  # out 5  out b % 8
  # adv 3. a = a / 8
  # jnz 0

  def find_a
    @solutions = []
    solve(0)
    solutions.min
  end

  # since the last step is divide by 8, check all values between 0 and 7 to see if their
  # output matches the last digits in the program. if it matches the end of the program,
  # multiply by 8 and try to find the previous possible 7 values. this repeats until
  # the output matches the program.
  # solution only works for the real problem, since the test data is a different program
  def solve(x)
    x.upto(x + 7) do |index|
      reset(index)
      execute
      if program[-output.size, output.size] == output
        solutions << index if program == output
        solve(index * 8)
      end
    end
  end

  private

  attr_reader :solutions

  def reset(a_value)
    @register_a = a_value
    @register_b = 0
    @register_c = 0
  end
end

parse = Parse.new(test: false)
computer = Computer.new(*parse.computer)
pp computer.execute.join(",")

computer = Computer2.new(*parse.computer)
pp computer.find_a
