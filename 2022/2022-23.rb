require "set"

class Grove
  def self.create
    lines = File.readlines("2022/data/2022-23.data", chomp: true)
    locations = Set.new
    lines.each_with_index do |line, row|
      line.each_char.with_index do |char, column|
        locations << [row, column] if char == "#"
      end
    end
    new locations
  end

  def simulate
    self.move_order = %i[north south west east]
    10.times do
      move
      self.move_order = move_order.rotate
    end
    row_range.size * column_range.size - count
  end

  def simulate_until_stop
    self.move_order = %i[north south west east]
    previous_locations = locations
    index = 1
    loop do
      print "\r#{index}"
      move
      break if previous_locations == locations

      self.move_order = move_order.rotate
      previous_locations = locations
      index += 1
    end
    index
  end

  def print_grid
    row_range.each do |row|
      puts column_range.map { |column| locations.include?([row, column]) ? "#" : "." }.join("")
    end
    puts
  end

  protected

  def initialize(locations)
    @locations = locations
    @count = locations.size
  end

  private

  attr_reader :count
  attr_accessor :locations, :move_order

  def row_range
    min_row, max_row = locations.map { |row, _column| row }.minmax
    min_row..max_row
  end

  def column_range
    min_column, max_column = locations.map { |_row, column| column }.minmax
    min_column..max_column
  end

  def move
    proposed_moves = Hash.new { [] }
    locations.each do |location|
      proposed_moves[propose_move(location)] += [location]
    end
    self.locations = proposed_moves.select { |_, locations| locations.size == 1 }.keys.to_set
    proposed_moves.select { |_, locations| locations.size > 1 }.each { |_, locations| self.locations |= locations }
    raise "something went wrong" unless locations.size == count
  end

  def propose_move(location)
    row, column = *location
    possible_moves = move_order.map do |direction|
      case direction
      when :north
        [row - 1, column] if can_move_north?(location)
      when :south
        [row + 1, column] if can_move_south?(location)
      when :west
        [row, column - 1] if can_move_west?(location)
      when :east
        [row, column + 1] if can_move_east?(location)
      end
    end.compact
    if possible_moves.size.zero? || possible_moves.size == 4
      location
    else
      possible_moves.first
    end
  end

  def can_move_north?(location)
    row, column = *location
    (column - 1..column + 1).none? do |c|
      locations.include? [row - 1, c]
    end
  end

  def can_move_south?(location)
    row, column = *location
    (column - 1..column + 1).none? do |c|
      locations.include? [row + 1, c]
    end
  end

  def can_move_west?(location)
    row, column = *location
    (row - 1..row + 1).none? do |r|
      locations.include? [r, column - 1]
    end
  end

  def can_move_east?(location)
    row, column = *location
    (row - 1..row + 1).none? do |r|
      locations.include? [r, column + 1]
    end
  end
end

grove = Grove.create
pp grove.simulate

grove = Grove.create
grove.simulate_until_stop
