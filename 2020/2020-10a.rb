input = File.read('2020/2020-10.data')

numbers = input.split("\n")
numbers = numbers.map(&:to_i).sort

differences = Hash.new { 0 }

previous = 0
numbers.each do |number|
  jolts = number - previous
  previous = number
  differences[jolts] += 1
end

pp differences

pp differences[1] * (differences[3] + 1)
