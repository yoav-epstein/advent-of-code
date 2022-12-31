input = File.read('2021/2021-17.data')

p input

vals = *input.chomp.scan(/x=(\d+)..(\d+), y=(.*)\.\.(.*)/)[0]
x_min, x_max, y_min, y_max = *(vals.map(&:to_i))

p x_min, x_max, y_min, y_max

0.upto(200) do |start_vy|
  y = 0
  vy = start_vy
  max_y = 0
  while y > y_min
    max_y = y if y > max_y
    y += vy
    vy -= 1
    if y >= y_min && y <= y_max
      puts "hit start_vy = #{start_vy}, y = #{y}, max_y = #{max_y}"
      break
    end
  end
end
