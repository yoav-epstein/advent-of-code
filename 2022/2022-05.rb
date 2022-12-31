data = File.read("2022/data/2022-05.data")

stack, move = *data.split("\n\n")

stack_lines = stack.split("\n").reverse

count = stack_lines.shift.size / 4 + 1

def initial_stacks(stack_lines, count)
  stacks = Array.new(count) { [] }
  stack_lines.each do |line|
    0.upto(count - 1) do |i|
      crate = line[i * 4 + 1]
      stacks[i].push(crate) unless crate == " " || crate.nil?
    end
  end
  stacks
end

stacks = initial_stacks(stack_lines, count)

move.split("\n").each do |line|
  num, from, to = */move (\d*) from (\d*) to (\d*)/.match(line).captures.map(&:to_i)
  num.times do
    stacks[to - 1].push(stacks[from - 1].pop)
  end
end

pp stacks.map(&:last).join

stacks = initial_stacks(stack_lines, count)

move.split("\n").each do |line|
  num, from, to = */move (\d*) from (\d*) to (\d*)/.match(line).captures.map(&:to_i)
  stacks[to - 1].concat(stacks[from - 1].pop(num))
end

pp stacks.map(&:last).join
