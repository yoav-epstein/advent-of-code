lines = File.readlines("2022/data/2022-12.data", chomp: true)

class Grid
  def initialize(grid)
    @grid = grid
    @grid[start[0]][start[1]] = "a"
    @grid[finish[0]][finish[1]] = "z"
  end

  def path
    @costs = Array.new(rows) { Array.new(cols) }
    @candidates = [[*start, 0]]
    search
  end

  def path_down
    @costs = Array.new(rows) { Array.new(cols) }
    @candidates = [[*finish, 0]]
    search_down
  end

  private

  attr_reader :grid, :costs, :candidates

  def search_down
    while candidate = candidates.shift do
      row, col, cost = candidate
      break cost if grid[row][col] == "a"
      next if costs[row][col] && costs[row][col] <= cost

      costs[row][col] = cost
      elevation = grid[row][col]

      check_down(row - 1, col, elevation, cost)
      check_down(row + 1, col, elevation, cost)
      check_down(row, col - 1, elevation, cost)
      check_down(row, col + 1, elevation, cost)
    end
  end

  def check_down(row, col, elevation, cost)
    return if row < 0 || row > rows - 1
    return if col < 0 || col > cols - 1
    return unless costs[row][col].nil?
    return if elevation.ord - grid[row][col].ord > 1

    candidates << [row, col, cost + 1]
  end

  def search
    while candidate = candidates.shift
      row, col, cost = candidate
      break cost if row == finish[0] && col == finish[1]
      next if costs[row][col] && costs[row][col] <= cost

      costs[row][col] = cost
      elevation = grid[row][col]

      check(row - 1, col, elevation, cost)
      check(row + 1, col, elevation, cost)
      check(row, col - 1, elevation, cost)
      check(row, col + 1, elevation, cost)
    end
  end

  def check(row, col, elevation, cost)
    return if row < 0 || row > rows - 1
    return if col < 0 || col > cols - 1
    return unless costs[row][col].nil?
    return if grid[row][col].ord - elevation.ord > 1

    candidates << [row, col, cost + 1]
  end

  def rows
    @rows ||= grid.size
  end

  def cols
    @cols ||= grid.first.size
  end

  def start
    return @start if @start

    grid.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        next unless col == "S"

        return @start = [row_index, col_index]
      end
    end
  end

  def finish
    return @finish if @finish

    grid.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        next unless col == "E"

        return @finish = [row_index, col_index]
      end
    end
  end
end

grid = Grid.new lines.map(&:chars)

pp grid.path
pp grid.path_down
