image = File.read('2019/2019-08.data')

width = 25
height = 6

data = image.strip.chars.map(&:to_i)
layers = data.each_slice(width * height).to_a

min_zeros = width * height
result = 0
layers.each do |layer|
  zeros = layer.count(&:zero?)
  next unless zeros < min_zeros

  min_zeros = zeros
  num_ones = layer.count { |p| p == 1 }
  num_twos = layer.count { |p| p == 2 }
  result = num_ones * num_twos
end
puts result
