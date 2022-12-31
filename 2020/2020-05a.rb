input = File.read('2020/2020-05.data')

numbers = input.split("\n")

def from_bin(number, zero, one)
  result = 0
  number.each_char do |c|
    result *= 2
    result += 1 if c == one
  end
  result
end

seats = numbers.map do |number|
  row = from_bin(number[0..6], 'F', 'B')
  column = from_bin(number[7..9], 'L', 'R')
  [row, column, row * 8 + column]
end

pp seats.map { |seat| seat[2] }.max
