input = File.read('2020/2020-06.data')

groups = input.split("\n\n")
groups = groups.map { |group|  group.split("\n") }

groups = groups.map do |group|
  histogram = Hash.new { 0 }
  group.each do |person|
    person.chars.each do |answer|
      histogram[answer] = histogram[answer] + 1
    end
  end

  [group.size, histogram]
end

groups = groups.map do |size, histogram|
  histogram.select { |_answer, count| count == size }.size
end

pp groups.sum
