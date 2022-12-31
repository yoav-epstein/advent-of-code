lines = File.read("2022/data/2022-08.data")

grid = lines.split("\n").map do |line|
  line.chars.map(&:to_i)
end

rows = grid.size
cols = grid.first.size

visible = Array.new(rows) { Array.new(cols) { 0 } }

def visible_from_top(grid, visible)
  cols = grid.first.size
  max = Array.new(cols) { -1 }
  count_max = 0

  grid.each_index do |row|
    0.upto(cols - 1) do |col|
      next if grid[row][col] <= max[col]

      visible[row][col] = 1
      max[col] = grid[row][col]
      count_max += 1 if max[col] == 9
    end
    break if count_max >= cols
  end
end

def visible_from_bottom(grid, visible)
  cols = grid.last.size
  max = Array.new(cols) { -1 }
  count_max = 0

  (grid.size - 1).downto(0).each do |row|
    0.upto(cols - 1) do |col|
      next if grid[row][col] <= max[col]

      visible[row][col] = 1
      max[col] = grid[row][col]
      count_max += 1 if max[col] == 9
    end
    break if count_max >= cols
  end
end

def visible_from_left(grid, visible)
  cols = grid.first.size

  grid.each_index do |row|
    max = -1
    0.upto(cols - 1).each do |col|
      next if grid[row][col] <= max

      visible[row][col] = 1
      max = grid[row][col]
      break if max == 9
    end
  end
end

def visible_from_right(grid, visible)
  cols = grid.first.size

  grid.each_index do |row|
    max = -1
    (cols - 1).downto(0).each do |col|
      next if grid[row][col] <= max

      visible[row][col] = 1
      max = grid[row][col]
      break if max == 9
    end
  end
end

visible_from_top(grid, visible)
visible_from_bottom(grid, visible)
visible_from_left(grid, visible)
visible_from_right(grid, visible)

pp visible.map(&:sum).sum

def score(grid, row, col)
  rows = grid.size
  cols = grid.first.size

  tree = grid[row][col]

  above = (row - 1).downto(1).take_while { |r| tree > grid[r][col] }.count + 1
  below = (row + 1).upto(rows - 2).take_while { |r| tree > grid[r][col] }.count + 1
  left = (col - 1).downto(1).take_while { |c| tree > grid[row][c] }.count + 1
  right = (col + 1).upto(cols - 2).take_while { |c| tree > grid[row][c] }.count + 1

  above * below * left * right
end

max_score = 1.upto(rows - 2).map do |row|
  1.upto(cols - 2).map do |col|
    score(grid, row, col)
  end.max
end.max

pp max_score
