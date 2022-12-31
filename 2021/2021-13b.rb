input = File.read('2021/2021-13.data', chomp: true)

dots, commands = input.split("\n\n")

dots = dots.split("\n").map do |coord|
  coord.split(',').map(&:to_i)
end
commands = commands.split("\n").map { |line| line.split(' ').last.split('=') }

def fold_y(dots, fold_y)
  dots.map do |x, y|
    if y > fold_y
      delta = y - fold_y
      [x, fold_y - delta]
    else
      [x, y]
    end
  end.uniq
end

def fold_x(dots, fold_x)
  dots.map do |x, y|
    if x > fold_x
      delta = x - fold_x
      [fold_x - delta, y]
    else
      [x, y]
    end
  end.uniq
end

def print_dots(dots)
  max_x = dots.map { |x, _y| x }.max
  max_y = dots.map { |_x, y| y }.max
  0.upto(max_y) do |y|
    0.upto(max_x) do |x|
      char = dots.include?([x, y]) ? '@ ' : '  '
      print char
    end
    puts
  end
end

commands.each do |direction, value|
  if direction == 'x'
    dots = fold_x(dots, value.to_i)
  else
    dots = fold_y(dots, value.to_i)
  end
end

print_dots(dots)
