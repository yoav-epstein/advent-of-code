input = File.read('2019/2019-03.data')

line1, line2 = *input.split("\n").map { |line| line.split(',') }

x = 0
y = 0
steps = 0
lines = line1.flat_map do |command|
  direction = command[0]
  distance = command[1..-1].to_i
  distance.times.map do
    steps += 1
    case direction
    when 'U'
      y -= 1
    when 'D'
      y += 1
    when 'L'
      x -= 1
    when 'R'
      x += 1
    end
    [x, y, steps]
  end
end

#puts lines.inspect

points = []
x = 0
y = 0
steps = 0
line2.each do |command|
  puts command
  direction = command[0]
  distance = command[1..-1].to_i
  distance.times do
    steps += 1
    case direction
    when 'U'
      y -= 1
    when 'D'
      y += 1
    when 'L'
      x -= 1
    when 'R'
      x += 1
    end
    match = lines.find { |line| line[0] == x && line[1] == y }
    points << [x, y, steps + match.last ] if match
  end
end

puts points.inspect
puts points.min_by(&:last).last
