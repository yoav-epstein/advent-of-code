input = File.read('2020/2020-01.data')

expenses = input.split("\n").map(&:to_i)

pairs = expenses.combination(2).select do |a, b|
  a + b == 2020
end

product = pairs.map do |a, b|
  a * b
end

pp product
