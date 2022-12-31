input = File.readlines('2021/2021-09.data', chomp: true)

grid = input.map do |row|
  row.split('').map(&:to_i)
end

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

def basin_size(row, col, grid)
  return 0 if row < 0 || col < 0

  height = grid.size
  width = grid[0].size
  return 0 if row >= height || col >= width
  return 0 if grid[row][col] == 9

  grid[row][col] = 9
  1 + basin_size(row - 1, col, grid) + basin_size(row + 1, col, grid) +
    basin_size(row, col - 1, grid) + basin_size(row, col + 1, grid)
end

height = grid.size
width = grid[0].size

basins = 0.upto(height - 1).flat_map do |row|
  0.upto(width - 1).map do |col|
    if low?(row, col, grid)
      grid = grid.map(&:dup)
      basin_size(row, col, grid)
    end
  end
end.compact.sort

p basins
p basins.last(3).reduce(&:*)
