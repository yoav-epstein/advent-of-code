lines = File.readlines("2022/data/2022-03.data")

sacks = lines.map do |line|
  line.chomp.chars.each_slice(line.size / 2).to_a
end

common = sacks.map do |s1, s2|
  (s1 & s2).join
end

def score(items)
  items.bytes.map do |byte|
    byte >= 97 ? byte - 96 : byte - 64 + 26
  end.sum
end

scores = common.map(&method(:score))

pp scores.sum

groups = lines.each_slice(3).map do |lines|
  lines.map { |line| line.chomp.chars }
end

common = groups.map { |s1, s2, s3| (s1 & s2 & s3).join }

scores = common.map(&method(:score))

pp scores.sum
