input = File.readlines('2021/2021-07.data', chomp: true)

positions = input[0].split(',').map(&:to_i)

min, max = positions.minmax

aligns = min.upto(max).map do |position|
  positions.map { |pos| (pos - position).abs }.sum
end

p aligns.min
