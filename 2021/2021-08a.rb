input = File.readlines('2021/2021-08.data', chomp: true)

digits = input.flat_map do |input|
  left, right = *input.split(' | ')
  right.split(' ').map(&:length)
end

counts = [2, 3, 4, 7].map do |digit|
  digits.count(digit)
end

p counts.sum
