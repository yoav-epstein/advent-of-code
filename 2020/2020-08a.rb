input = File.read('2020/2020-08.data')

program = input.split("\n")
program = program.map do |line|
  operator, operand = line.split(' ')
  [operator, operand.to_i, nil]
end

def execute(program, acc, pc)
  while true
    command = program[pc]
    return acc if command[2]

    command[2] = acc

    case command[0]
    when 'nop'
      pc += 1
    when 'jmp'
      pc += command[1]
    when 'acc'
      acc += command[1]
      pc += 1
    end

  end
end

pp execute(program, 0, 0)
