input = File.readlines('2021/2021-07.data', chomp: true)

positions = input[0].split(',').map(&:to_i)

min, max = positions.minmax

aligns = min.upto(max).map do |position|
  positions.map do |pos|
    delta = (pos - position).abs
    delta * (delta + 1) / 2
  end.sum
end

p aligns.min
