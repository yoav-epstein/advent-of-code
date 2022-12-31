inputs = File.readlines('2021/2021-11.data', chomp: true)

grid = inputs.map do |input|
  input.each_char.map(&:to_i)
end

p grid

def increment(grid, row, col)
  return if row < 0 || col < 0
  return if row >= grid.size || col >= grid[0].size

  grid[row][col] += 1
  flash(grid, row, col) if grid[row][col] == 10
end

def flash(grid, row, col)
  (row - 1).upto(row + 1) do |r|
    (col - 1).upto(col + 1) do |c|
      increment(grid, r, c)
    end
  end
end

def step(grid)
  rows = grid.size
  cols = grid[0].size
  0.upto(rows) do |row|
    0.upto(cols) do |col|
      increment(grid, row, col)
    end
  end
  flashes = 0
  0.upto(rows - 1) do |row|
    0.upto(cols - 1) do |col|
      if grid[row][col] > 9
        flashes += 1
        grid[row][col] = 0
      end
    end
  end
  flashes
end

count = 0
loop do
  flashes = step(grid)
  p flashes
  count += 1
  break if flashes == 100
end

p count
