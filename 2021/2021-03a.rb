input = File.readlines('2021/2021-03.data', chomp: true)

diag = input.map { |code| code.chars.map(&:to_i) }.transpose

entries = diag[0].size / 2

gamma = diag.map { |code| code.count(1) }.map { |count| count > entries ? 1 : 0 }


gamma = gamma.reduce(0) { |acc, v| acc * 2 + v }

p gamma

bits = input.first.length

epsilon = 2 ** bits - 1 - gamma

p epsilon


p gamma * epsilon
