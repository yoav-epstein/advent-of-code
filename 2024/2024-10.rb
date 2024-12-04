require "set"
require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def topography
    input.readlines.map do |line|
      line.chomp.split("").map(&:to_i)
    end
  end

  private

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class TrailFinder
  def initialize(topography)
    @topography = topography
  end

  def trails
    heads.sum { |head| peaks_from(*head) }
  end

  private

  attr_reader :topography

  def rows
    @rows ||= topography.size
  end

  def cols
    @cols ||= topography[0].size
  end

  def offsets
    @offsets ||= [[-1, 0], [1, 0], [0, -1], [0, 1]]
  end

  def heads
    return @heads if defined?(@heads)

    @heads = []
    0.upto(rows - 1).each do |row|
      0.upto(cols - 1).each do |col|
        @heads << [row, col] if topography[row][col].zero?
      end
    end
    @heads
  end

  def peaks_from(row, col)
    peaks = 0
    queue = [[row, col]]
    visited = Set.new
    until queue.empty?
      row, col = queue.shift
      next if visited.include?([row, col])

      visited << [row, col]
      height = topography[row][col]
      if height == 9
        peaks += 1
        next
      end

      offsets.each do |row_offset, col_offset|
        next_row = row + row_offset
        next_col = col + col_offset
        next if next_row.negative? || next_col.negative? || next_row >= rows || next_col >= cols

        next_height = topography[next_row][next_col]
        next unless next_height == height + 1

        queue << [next_row, next_col]
      end
    end

    peaks
  end
end

class TrailFinder2 < TrailFinder
  def peaks_from(row, col)
    height = topography[row][col]
    return 1 if height == 9

    offsets.filter_map do |row_offset, col_offset|
      next_row = row + row_offset
      next_col = col + col_offset
      next if next_row.negative? || next_col.negative? || next_row >= rows || next_col >= cols

      next_height = topography[next_row][next_col]
      next unless next_height == height + 1

      peaks_from(next_row, next_col)
    end.sum
  end
end

parse = Parse.new(test: false)

finder = TrailFinder.new(parse.topography)

pp finder.trails

finder = TrailFinder2.new(parse.topography)

pp finder.trails
