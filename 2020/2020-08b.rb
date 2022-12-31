input = File.read('2020/2020-08.data')

program = input.split("\n")
program = program.map do |line|
  operator, operand = line.split(' ')
  [operator, operand.to_i, nil]
end

def execute(program, acc, pc)
  while true
    command = program[pc]
    return acc if command.nil?
    return acc.to_s if command[2]

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

execute(program, 0, 0)

program.length.times do |index|
  next unless program[index][0] == 'nop'

  program.each { |command| command[2] = nil }
  program[index][0] = 'jmp'
  result = execute(program, 0, 0)
  puts result if result.is_a?(Integer)
  program[index][0] = 'nop'
end

program.length.times do |index|
  next unless program[index][0] == 'jmp'

  program.each { |command| command[2] = nil }
  program[index][0] = 'nop'
  result = execute(program, 0, 0)
  puts result if result.is_a?(Integer)
  program[index][0] = 'jmp'
end
