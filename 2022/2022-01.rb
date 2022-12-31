lines = File.readlines("2022/data/2022-01.data")

sum = 0
sums = []
lines.each do |line|
  if line == "\n"
    sums << sum
    sum = 0
  else
    sum += line.to_i
  end
end

sums = sums.sort

pp sums.last

pp sums.last(3).sum
