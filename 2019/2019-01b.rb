input = File.read('2019/2019-01.data')

def fuel(mass)
  return 0 if mass < 9

  f = mass / 3 - 2
  f + fuel(f)
end

masses = input.split("\n").map(&:to_i)

puts masses.map(&method(:fuel)).sum
