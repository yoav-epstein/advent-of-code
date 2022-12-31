input = File.read('2020/2020-09.data')

numbers = input.split("\n")
numbers = numbers.map(&:to_i)

preamble_length = 25

preamble = numbers.shift(preamble_length)

bad_numbers = numbers.reject do |number|
  valid_numbers = preamble.combination(2).map(&:sum)
  preamble.shift
  preamble << number
  valid_numbers.include?(number)
end

pp bad_numbers
