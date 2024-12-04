require "set"
require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def garden
    input.readlines.map(&:chomp)
  end

  private

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class Garden
  def initialize(garden)
    @garden = garden
  end

  def fences
    fences = []
    visited = Set.new

    0.upto(rows - 1) do |garden_row|
      0.upto(cols - 1) do |garden_col|
        next if visited.include?([garden_row, garden_col])

        area = 0
        plant = garden[garden_row][garden_col]
        queue = [[garden_row, garden_col]]
        plots = Set.new

        until queue.empty?
          row, col = queue.shift
          next if visited.include?([row, col])

          visited << [row, col]
          plots << [row, col]

          area += 1

          queue << [row - 1, col] if row.positive? && garden[row - 1][col] == plant
          queue << [row + 1, col] if row < rows - 1 && garden[row + 1][col] == plant
          queue << [row, col - 1] if col.positive? && garden[row][col - 1] == plant
          queue << [row, col + 1] if col < cols - 1 && garden[row][col + 1] == plant
        end

        fences << [plant, area * perimeter(plots)]
      end
    end

    fences
  end

  private

  attr_reader :garden

  def rows
    garden.size
  end

  def cols
    garden[0].size
  end

  def perimeter(plots)
    count = 0
    plots.each do |row, col|
      count += 1 unless plots.include?([row - 1, col])
      count += 1 unless plots.include?([row + 1, col])
      count += 1 unless plots.include?([row, col - 1])
      count += 1 unless plots.include?([row, col + 1])
    end
    count
  end
end

class Garden2 < Garden
  private

  def perimeter(plots)
    count = 0

    0.upto(rows - 1) do |garden_row|
      cols = plots.select { |row, _col| row == garden_row }.map(&:last).sort
      tops = cols.reject { |col| plots.include?([garden_row - 1, col]) }
      bottoms = cols.reject { |col| plots.include?([garden_row + 1, col]) }

      count += sections(tops) + sections(bottoms)
    end

    0.upto(cols - 1) do |garden_col|
      rows = plots.select { |_row, col| col == garden_col }.map(&:first).sort
      lefts = rows.reject { |row| plots.include?([row, garden_col - 1]) }
      rights = rows.reject { |row| plots.include?([row, garden_col + 1]) }

      count += sections(lefts) + sections(rights)
    end

    count
  end

  def sections(values)
    return 0 if values.empty?

    values.each_cons(2).sum(1) do |value1, value2|
      value1 + 1 == value2 ? 0 : 1
    end
  end
end

parse = Parse.new(test: false)

garden = Garden.new(parse.garden)
pp garden.fences.map(&:last).sum

garden = Garden2.new(parse.garden)
pp garden.fences.map(&:last).sum
