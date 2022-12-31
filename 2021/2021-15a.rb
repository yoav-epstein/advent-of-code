inputs = File.readlines('2021/2021-15.data', chomp: true)

risks = inputs.map do |input|
  input.split('').map(&:to_i)
end

p risks

rows = risks.size
cols = risks[0].size

sums = Array.new(rows) { [] }
sums[0][0] = 0
0.upto(rows - 1) do |row|
  puts "row = #{row}"
  0.upto(cols - 1) do |col|
    next if row == 0 && col == 0

    choices = []
    choices << sums[row - 1][col] if row > 0
    choices << sums[row][col - 1] if col > 0
    sums[row][col] = choices.min + risks[row][col]
  end
end

p sums[rows - 1][cols - 1]
