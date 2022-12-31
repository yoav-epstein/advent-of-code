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

def max_power(grid, size)
  max_power = 0
  max_x = 0
  max_y = 0
  0.upto(300 - size) do |y|
    0.upto(300 - size) do |x|
      local = 0
      size.times do |i|
        local += grid[y + i][x..(x + size - 1)].sum
      end
      next if max_power > local

      max_power = local
      max_x = x + 1
      max_y = y + 1
    end
  end
  puts "x = #{max_x}, y = #{max_y}, power = #{max_power}, grid = #{size}"

  [max_power, max_x, max_y]
end

max_power = 0
max_x = 0
max_y = 0
max_grid = 0
3.upto(50) do |size|
  result = max_power(grid, size)
  next if max_power > result[0]

  max_power, max_x, max_y = *result
  max_grid = size
end

puts "x = #{max_x}, y = #{max_y}, power = #{max_power}, grid = #{max_grid}"
