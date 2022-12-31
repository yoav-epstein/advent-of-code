inputs = File.readlines('2021/2021-13.data', chomp: true)

dots = inputs.map do |input|
  input.split(',').map(&:to_i)
end

p dots

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

p dots.size

# dots = fold_y(dots, 7)
#
# p dots
#
# dots = fold_x(dots, 5)
#
# p dots.size

dots = fold_x(dots, 655)
p dots.size

# fold along x=655
# fold along y=447
# fold along x=327
# fold along y=223
# fold along x=163
# fold along y=111
# fold along x=81
# fold along y=55
# fold along x=40
# fold along y=27
# fold along y=13
# fold along y=6
