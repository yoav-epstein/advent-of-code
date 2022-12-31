require "set"

lines = File.readlines("2022/data/2022-09.data", chomp: true)

class Grid
  def initialize(knots)
    @knots = knots
    @knot_rows = [0] * knots
    @knot_cols = [0] * knots
    @visited = Set.new
    record_visited
  end

  def move(direction, count)
    count.times do
      move_head direction
      1.upto(knots - 1).each(&method(:move_knot))
      record_visited
    end
  end

  def visited_count
    visited.size
  end

  private

  attr_reader :knots, :knot_rows, :knot_cols, :visited

  def move_head(direction)
    case direction
    when "R"
      knot_cols[0] += 1
    when "L"
      knot_cols[0] -= 1
    when "D"
      knot_rows[0] += 1
    when "U"
      knot_rows[0] -= 1
    end
  end

  def move_knot(knot)
    return if touching?(knot)

    knot_rows[knot] += delta_row(knot).clamp(-1, 1)
    knot_cols[knot] += delta_col(knot).clamp(-1, 1)
  end

  def record_visited
    visited << [tail_row, tail_col]
  end

  def touching?(knot)
    delta_row(knot).abs <= 1 && delta_col(knot).abs <= 1
  end

  def delta_row(knot)
    knot_rows[knot - 1] - knot_rows[knot]
  end

  def delta_col(knot)
    knot_cols[knot - 1] - knot_cols[knot]
  end

  def tail_row
    knot_rows[knots - 1]
  end

  def tail_col
    knot_cols[knots - 1]
  end
end

grid = Grid.new(2)
lines.each { |line| grid.move(line[0], line[2..].to_i) }

pp grid.visited_count

grid = Grid.new(10)
lines.each { |line| grid.move(line[0], line[2..].to_i) }

pp grid.visited_count
