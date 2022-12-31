input = File.read('2020/2020-10.data')

numbers = input.split("\n")
numbers = numbers.map(&:to_i).sort
numbers << numbers.max + 3

previous = 0
chain = []
chains = []
numbers.each do |number|
  jolts = number - previous
  previous = number

  if jolts == 3
    chains << chain unless chain.empty?
    chain = []
  else
    chain << jolts
  end
end

pp chains

chains = chains.map(&:size)

pp chains

counts = {
  0 => 1,
  1 => 1,
  2 => 2,
  3 => 4
}

4.upto(10) do |count|
  counts[count] = counts[count - 1] + counts[count -2] + counts[count - 3]
end

pp counts

chains = chains.map { |count| counts[count] }

pp chains

pp chains.reduce(&:*)
