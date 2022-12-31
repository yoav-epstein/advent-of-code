inputs = File.read('2021/2021-14.data')

start, rules = inputs.split("\n\n")

start = start.split('')
rules = rules.split("\n").map do |rule|
  k, v = rule.split(' -> ')
  [k.split(''), v]
end.to_h

p start
p rules

counts = Hash.new { 0 }
start.each_cons(2).each do |pair|
  counts[pair] += 1
end

40.times do
  new_counts = Hash.new { 0 }

  counts.each do |pair, count|
    new_counts[[pair[0], rules[pair]]] += count
    new_counts[[rules[pair], pair[1]]] += count
  end

  counts = new_counts
end

tally = Hash.new { 0 }
tally[start[-1]] = 1
counts.each do |pair, count|
  tally[pair[0]] += count
end

p tally.sort.to_h
min, max = tally.values.minmax
p max - min
