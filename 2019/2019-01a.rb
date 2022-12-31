input = File.read('2019/2019-01.data')

def fuel(mass)
  mass / 3 - 2
end

masses = input.split("\n").map(&:to_i)

puts masses.map(&method(:fuel)).sum
