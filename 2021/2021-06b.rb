input = File.readlines('2021/2021-06.data', chomp: true)

ages = input[0].split(',').map(&:to_i)

cache = {}

def estimate(age, days, cache)
  return 0 if days <= 0
  return cache[[age, days]] if cache[[age, days]]

  count = 1
  day = days - age
  until day < 0
    count += estimate(9, day, cache)
    day -= 7
  end
  count
  cache[[age, days]] = count
end

p ages

estimates = (1..6).map do |age|
  [age, estimate(age, 256, cache)]
end.to_h

p estimates

total = ages.map do |age|
  estimates[age]
end.sum

p total
