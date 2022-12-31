input = File.readlines('2021/2021-09.data', chomp: true)

grid = input.map do |row|
  row.split('').map(&:to_i)
end

p grid

def low?(row, col, grid)
  height = grid.size
  width = grid[0].size
  cell = grid[row][col]
  return false if col > 0 && grid[row][col - 1] <= cell
  return false if row < height - 1 && grid[row + 1][col] <= cell
  return false if col < width - 1 && grid[row][col + 1] <= cell
  return false if row > 0 && grid[row - 1][col] <= cell
  p "low row = #{row}, col = #{col}, cell = #{cell}"
  true
end

risk_level = 0

height = grid.size
width = grid[0].size

0.upto(height - 1) do |row|
  0.upto(width - 1) do |col|
    risk_level += 1 + grid[row][col] if low?(row, col, grid)
  end
end

p risk_level
