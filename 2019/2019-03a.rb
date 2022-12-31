input = File.read('2019/2019-03.data')

line1, line2 = *input.split("\n").map { |line| line.split(',') }

x = 0
y = 0
lines = line1.map do |command|
  direction = command[0]
  distance = command[1..-1].to_i
  case direction
  when 'U'
    y -= distance
    [x..x, y..(y + distance)]
  when 'D'
    y += distance
    [x..x, (y - distance)..y]
  when 'L'
    x -= distance
    [x..(x + distance), y..y]
  when 'R'
    x += distance
    [(x - distance)..x, y..y]
  end
end

puts lines.inspect

points = []
x = 0
y = 0
line2.each do |command|
  direction = command[0]
  distance = command[1..-1].to_i
  case direction
  when 'U'
    distance.times do
      points << [x, y] if lines.any? { |line| line.first.cover?(x) && line.last.cover?(y) }
      y -= 1
    end
  when 'D'
    distance.times do
      points << [x, y] if lines.any? { |line| line.first.cover?(x) && line.last.cover?(y) }
      y += 1
    end
  when 'L'
    distance.times do
      points << [x, y] if lines.any? { |line| line.first.cover?(x) && line.last.cover?(y) }
      x -= 1
    end
  when 'R'
    distance.times do
      points << [x, y] if lines.any? { |line| line.first.cover?(x) && line.last.cover?(y) }
      x += 1
    end
  end
end

points.shift
puts points.inspect

puts points.map { |point| point.first.abs + point.last.abs }.min
