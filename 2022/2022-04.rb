lines = File.readlines("2022/data/2022-04.data")

assignments = lines.map do |line|
  a1, a2, b1, b2 = */(\d*)-(\d*),(\d*)-(\d*)/.match(line).captures.map(&:to_i)
  [a1..a2, b1..b2]
end

contain = assignments.select do |a, b|
  a.cover?(b) || b.cover?(a)
end

overlap = assignments.select do |a, b|
  a.include?(b.first) || b.include?(a.first)
end

pp contain.size

pp overlap.size
