inputs = File.readlines('2021/2021-15.data', chomp: true)

risks = inputs.map do |input|
  input.split('').map(&:to_i)
end


new_risks = risks.map do |row|
  5.times.flat_map do |i|
    row.map do |val|
      new_val = val + i
      new_val > 9 ? new_val - 9 : new_val
    end
  end
end

risks = 5.times.flat_map do |i|
  new_risks.map do |row|
    row.map do |val|
      new_val = val + i
      new_val > 9 ? new_val - 9 : new_val
    end
  end
end

rows = risks.size
cols = risks[0].size

sums = Array.new(rows) { [] }
sums[0][0] = 10

choices = [[0, 0, 0]]
sum = while choices
  choices.sort!

  sum, row, col = choices.shift
  p "row = #{row}, col = #{col}"

  break sum if row == (rows -1) && col == (cols - 1)
  next if sums[row][col] && sums[row][col] <= sum

  sums[row][col] = sum

  choices << [sum + risks[row - 1][col], row - 1, col] if row > 0
  choices << [sum + risks[row][col - 1], row, col - 1] if col > 0
  choices << [sum + risks[row + 1][col], row + 1, col] if row < rows - 1
  choices << [sum + risks[row][col + 1], row, col + 1] if col < cols - 1
end

p sum
