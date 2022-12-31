input = File.read('2020/2020-06.data')

groups = input.split("\n\n")
groups = groups.map { |group|  group.split("\n") }

groups = groups.map do |group|
  group.flat_map do |person|
    person.chars
  end.uniq
end

pp groups.map { |group| group.size }.sum
