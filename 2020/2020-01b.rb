input = File.read('2020/2020/2020-01.data')

expenses = input.split("\n").map(&:to_i)

pairs = expenses.combination(3).select do |a, b, c|
  a + b + c == 2020
end

product = pairs.map do |a, b, c|
  a * b * c
end

pp product
