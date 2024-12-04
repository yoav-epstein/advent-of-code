require "set"
require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def maze
    @warehouse ||= input.readlines.map(&:chomp)
  end

  private

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class Maze
  def initialize(maze)
    @maze = maze
  end

  def path
    visited = Set.new
    offset = 0
    row = rows - 2
    col = 1
    cost = 0
    queue = []
    route = []

    until row == 1 && col == cols - 2
      if visited.include?([row, col, offset])
        cost, offset, row, col, route = queue.shift
        next
      end

      visited << [row, col, offset]

      4.times do |index|
        next_row = row + offsets[index][0]
        next_col = col + offsets[index][1]
        next if maze[next_row][next_col] == "#"
        next if (index - offset).abs == 2

        next_cost = index == offset ? cost + 1 : cost + 1001
        queue << [next_cost, index, next_row, next_col, route + [[row, col]]]
      end

      cost, offset, row, col, route = queue.sort!.shift
      while queue[0] && queue[0][0] == cost && queue[0][1] == offset && queue[0][2] == row && queue[0][3] == col
        route |= queue.shift[4]
      end
    end
    [cost, route + [[row, col]]]
  end

  private

  attr_reader :maze

  def offsets
    @offsets ||= [[0, 1], [1, 0], [0, -1], [-1, 0]]
  end

  def rows
    @rows ||= maze.size
  end

  def cols
    @cols ||= maze[0].size
  end
end

parse = Parse.new(test: false)
maze = Maze.new(parse.maze)
cost, route = maze.path
pp cost
pp route.size
