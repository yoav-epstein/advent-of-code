input = File.read('2020/2020-09.data')

numbers = input.split("\n")
numbers = numbers.map(&:to_i)

total = 731031916

sum = 0
values = []
numbers.each do |number|
  break values if sum == total

  values << number
  sum += number

  while sum > total
    sum -= values.shift
  end
end

pp values.minmax.sum
