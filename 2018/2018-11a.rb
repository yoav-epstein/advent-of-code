def power(x, y, serial)
  rack_id = x + 10
  (rack_id * y + serial) * rack_id % 1000 / 100 - 5
end

serial = 5719

grid = 1.upto(300).map do |y|
  1.upto(300).map do |x|
    power(x, y, serial)
  end
end

max_power = 0
max_x = 0
max_y = 0
0.upto(297) do |y|
  0.upto(297) do |x|
    local = grid[y][x] + grid[y][x + 1] + grid[y][x + 2]
    local += grid[y + 1][x] + grid[y + 1][x + 1] + grid[y + 1][x + 2]
    local += grid[y + 2][x] + grid[y + 2][x + 1] + grid[y + 2][x + 2]
    next if max_power > local

    max_power = local
    max_x = x + 1
    max_y = y + 1
  end
end

puts "x = #{max_x}, y = #{max_y}, power = #{max_power}"
