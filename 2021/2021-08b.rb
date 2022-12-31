input = File.readlines('2021/2021-08.data', chomp: true)

hash = {
  '012456' => 0,
  '25' => 1,
  '02346' => 2,
  '02356' => 3,
  '1235' => 4,
  '01356' => 5,
  '013456' => 6,
  '025' => 7,
  '0123456' => 8,
  '012356' => 9
}

def map_digit_to_number(digit, order, hash)
  key = digit.map do |d|
    order.index(d)
  end.sort.join
  hash[key]
end

def valid?(left, order, hash)
  left.all? do |digit|
    map_digit_to_number(digit, order, hash)
  end
end

puzzles = input.map do |input|
  left, right = *input.split(' | ')
  [left.split(' '), right.split(' ')]
end

results = puzzles.map do |puzzle|
  left, right = *puzzle
  left = left.map { |str| str.split('').sort }
  right = right.map { |str| str.split('').sort }
  ('a'..'g').to_a.permutation(7).each do |order|
    if valid?(left, order, hash)
      reading = right.map do |digit|
        map_digit_to_number(digit, order, hash)
      end.join.to_i
      break reading
    end
  end
end

p results
p results.sum
