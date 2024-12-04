require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def warehouse
    @warehouse ||= input.readlines.map(&:chomp).slice_after(&:empty?).to_a
  end

  private

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class Warehouse
  def initialize(warehouse, moves)
    @warehouse = warehouse.reject(&:empty?).map(&:chars)
    @moves = moves.join
  end

  def move_robot
    row, col = robot
    moves.each_char do |move|
      row, col = case move
                 when "<"
                   move(row, col, 0, -1, "@")
                 when ">"
                   move(row, col, 0, 1,  "@")
                 when "^"
                   move(row, col, -1, 0, "@")
                 when "v"
                   move(row, col, 1, 0, "@")
                 end
    end
  end

  def gps
    total = 0
    1.upto(rows - 2).each do |row|
      1.upto(cols - 2).each do |col|
        total += row * 100 + col if warehouse[row][col] == "O" || warehouse[row][col] == "["
      end
    end
    total
  end

  private

  attr_reader :warehouse, :moves

  def move(row, col, row_offset, col_offset, object)
    return [row, col] if warehouse[row + row_offset][col + col_offset] == "#"

    if warehouse[row + row_offset][col + col_offset] == "O"
      move(row + row_offset, col + col_offset, row_offset, col_offset, "O")
    end

    return [row, col] unless warehouse[row + row_offset][col + col_offset] == "."

    warehouse[row + row_offset][col + col_offset] = object
    warehouse[row][col] = "."

    [row + row_offset, col + col_offset]
  end

  def robot
    1.upto(rows - 2).each do |row|
      1.upto(cols - 2).each do |col|
        return [row, col] if warehouse[row][col] == "@"
      end
    end
  end

  def rows
    @rows ||= warehouse.size
  end

  def cols
    @cols ||= warehouse.first.size
  end
end

class Warehouse2 < Warehouse
  def initialize(warehouse, moves)
    super
    @warehouse = warehouse.reject(&:empty?).map do |line|
      line.each_char.flat_map do |char|
        case char
        when "O"
          %w([ ])
        when "@"
          %w[@ .]
        else
          [char, char]
        end
      end
    end
  end

  def move_robot
    row, col = robot
    moves.each_char do |move|
      row, col = case move
                 when "<"
                   move_left_right(row, col, -1, "@")
                 when ">"
                   move_left_right(row, col, 1,  "@")
                 when "^"
                   move_up_down(row, col, -1, "@")
                 when "v"
                   move_up_down(row, col, 1, "@")
                 end
    end
  end

  private

  def move_left_right(row, col, col_offset, object)
    return [row, col] if warehouse[row][col + col_offset] == "#"

    if warehouse[row][col + col_offset] == "]"
      move_left_right(row, col + col_offset, col_offset, "]")
    end
    if warehouse[row][col + col_offset] == "["
      move_left_right(row, col + col_offset, col_offset, "[")
    end

    return [row, col] unless warehouse[row][col + col_offset] == "."

    warehouse[row][col + col_offset] = object
    warehouse[row][col] = "."

    [row, col + col_offset]
  end

  def can_move?(row, col, row_offset)
    return true if warehouse[row + row_offset][col] == "."
    return false if warehouse[row + row_offset][col] == "#"

    if warehouse[row + row_offset][col] == "]"
      can_move?(row + row_offset, col - 1, row_offset) && can_move?(row + row_offset, col, row_offset)
    else
      can_move?(row + row_offset, col, row_offset) && can_move?(row + row_offset, col + 1, row_offset)
    end
  end

  def move_up_down(row, col, row_offset, object)
    return [row, col] if warehouse[row + row_offset][col] == "#"

    if warehouse[row + row_offset][col] == "]" &&
       can_move?(row + row_offset, col - 1, row_offset) &&
       can_move?(row + row_offset, col, row_offset)

      move_up_down(row + row_offset, col - 1, row_offset, "[")
      move_up_down(row + row_offset, col, row_offset, "]")
    end
    if warehouse[row + row_offset][col] == "[" &&
       can_move?(row + row_offset, col, row_offset) &&
       can_move?(row + row_offset, col + 1, row_offset)

      move_up_down(row + row_offset, col, row_offset, "[")
      move_up_down(row + row_offset, col + 1, row_offset, "]")
    end

    return [row, col] unless warehouse[row + row_offset][col] == "."

    warehouse[row + row_offset][col] = object
    warehouse[row][col] = "."

    [row + row_offset, col]
  end
end

parse = Parse.new(test: false)
warehouse = Warehouse.new(*parse.warehouse)
warehouse.move_robot
pp warehouse.gps

warehouse = Warehouse2.new(*parse.warehouse)
warehouse.move_robot
pp warehouse.gps
