require "set"
require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def grid
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

class Antenna
  def initialize(grid, harmonics:)
    @grid = grid
    @harmonics = harmonics
  end

  def antinodes
    return @antinodes if defined?(@antinodes)

    @antinodes = Set.new
    antennas.each do |antenna, nodes|
      nodes.combination(2).map do |node_a, node_b|
        delta_row = node_a[0] - node_b[0]
        delta_col = node_a[1] - node_b[1]

        antinodes_for(node_a[0], node_a[1], delta_row, delta_col)
        antinodes_for(node_b[0], node_b[1], -delta_row, -delta_col)
      end
    end
    @antinodes
  end

  private

  attr_reader :grid, :harmonics

  def antennas
    @antennas = Hash.new { [] }
    0.upto(rows - 1).each do |row|
      0.upto(cols - 1).each do |col|
        antenna = grid[row][col]
        next if antenna == "."

        @antennas[antenna] <<= [row, col]
      end
    end
    @antennas
  end

  def rows
    @rows ||= @grid.size
  end

  def cols
    @cols ||= @grid.first.size
  end

  def antinodes_for(start_row, start_col, delta_row, delta_col)
    start = harmonics ? 0 : 1
    times = harmonics ? 100 : 1

    start.upto(times) do |index|
      row = start_row + delta_row * index
      col = start_col + delta_col * index

      break unless row >= 0 && row < rows && col >= 0 && col < cols

      @antinodes << [row, col]
    end
  end
end

parse = Parse.new(test: false)

antenna = Antenna.new(parse.grid, harmonics: false)

pp antenna.antinodes.size

antenna = Antenna.new(parse.grid, harmonics: true)

pp antenna.antinodes.size
