require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def grid
    @grid ||= input.readlines.map(&:chomp).map(&:chars)
  end

  private

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class XmasFinder
  def initialize(grid)
    @grid = grid
  end

  def count
    count = 0

    0.upto(rows - 1) do |row|
      0.upto(cols - 1) do |col|
        next unless grid[row][col] == "X"

        offsets.map do |row_offset, col_offset|
          word = ""
          4.times.map do |index|
            next_row = row + row_offset * index
            next_col = col + col_offset * index
            break if next_row.negative? || next_col.negative? || next_row >= rows || next_col >= cols

            word += grid[next_row][next_col]
          end

          count += 1 if word == "XMAS"
        end
      end
    end

    count
  end

  private

  attr_reader :grid

  def offsets
    @offsets ||= [
      [0, -1],
      [1, -1],
      [1, 0],
      [1, 1],
      [0, 1],
      [-1, 1],
      [-1, 0],
      [-1, -1]
    ]
  end

  def rows
    @rows ||= @grid.size
  end

  def cols
    @cols ||= @grid.first.size
  end
end

class CrossFinder
  def initialize(grid)
    @grid = grid
  end

  def count
    count = 0

    1.upto(rows - 2) do |row|
      1.upto(cols - 2) do |col|
        next unless grid[row][col] == "A"

        x1 = grid[row - 1][col - 1] + grid[row + 1][col + 1]
        x2 = grid[row - 1][col + 1] + grid[row + 1][col - 1]

        count += 1 if cross.include?(x1) && cross.include?(x2)
      end
    end

    count
  end

  private

  attr_reader :grid

  def rows
    @rows ||= @grid.size
  end

  def cols
    @cols ||= @grid.first.size
  end

  def cross
    @cross ||= %w[MS SM]
  end
end

parse = Parse.new(test: false)

pp XmasFinder.new(parse.grid).count
pp CrossFinder.new(parse.grid).count
