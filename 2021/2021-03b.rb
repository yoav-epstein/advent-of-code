input = File.readlines('2021/2021-03.data', chomp: true)

oxygen = input.map { |code| code.chars.map(&:to_i) }
co2 = input.map { |code| code.chars.map(&:to_i) }

bits = input.first.length

bits.times do |index|
  codes = oxygen.transpose[index]
  find = codes.count(1) * 2 >= codes.size ? 1 : 0

  oxygen = oxygen.select { |o| o[index] == find }
  break if oxygen.size == 1
end

bits.times do |index|
  codes = co2.transpose[index]
  find = codes.count(1) * 2 >= codes.size ? 0 : 1

  co2 = co2.select { |o| o[index] == find }
  break if co2.size == 1
end

oxygen = oxygen[0].reduce(0) { |acc, v| acc * 2 + v }
co2 = co2[0].reduce(0) { |acc, v| acc * 2 + v }
p oxygen
p co2

p oxygen * co2
