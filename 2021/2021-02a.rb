input = File.readlines('2021/2021-02.data')

commands = input.map do |line|
  command, count = *line.split(' ')
  [command, count.to_i]
end

horizontal = 0
depth = 0

commands.each do |command, count|
  case command
  when 'forward'
    horizontal += count
  when 'down'
    depth += count
  when 'up'
    depth -= count
  end
end

pp horizontal * depth
