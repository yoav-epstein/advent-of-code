inputs = File.read('2021/2021-14.data', chomp: true)

start, pairs = inputs.split("\n\n")

start = start.split('')
pairs = pairs.split("\n").map do |pair|
  k, v = pair.split(' -> ')
  [k.split(''), v]
end.to_h

p start
p pairs

10.times do
  last = start[-1]
  start = start.each_cons(2).flat_map do |p|
    [p[0], pairs[p]]
  end
  start << last
  p start.join('')
end

tally = Hash.new(0)
start.each do |c|
  tally[c] = tally[c] + 1
end

min, max = tally.values.minmax

p max - min
