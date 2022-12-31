require "set"

class Blizzard
  def initialize(row, column, direction, max_row, max_column)
    @row = row
    @column = column
    @max_row = max_row
    @max_column = max_column

    case direction
    when "<"
      @row_offset = 0
      @column_offset = -1
    when ">"
      @row_offset = 0
      @column_offset = 1
    when "^"
      @row_offset = -1
      @column_offset = 0
    when "v"
      @row_offset = 1
      @column_offset = 0
    end
  end

  def move
    self.row += row_offset
    self.row = max_row if row.zero?
    self.row = 1 if row > max_row

    self.column += column_offset
    self.column = max_column if column.zero?
    self.column = 1 if column > max_column

    [row, column]
  end

  private

  attr_accessor :row, :column
  attr_reader :row_offset, :column_offset, :max_row, :max_column
end

class Basin
  def self.create
    lines = File.readlines("2022/data/2022-24.data", chomp: true)
    max_row = lines.size - 2
    max_column = lines.first.size - 2
    blizzards = []
    lines.each_with_index do |line, row|
      line.each_char.with_index do |direction, column|
        next if %w[# .].include?(direction)

        blizzards << Blizzard.new(row, column, direction, max_row, max_column)
      end
    end
    new(blizzards, max_row, max_column)
  end

  def path_to_exit
    path_to([0, 1], [max_row + 1, max_column])
  end

  def path_to_entrance
    path_to([max_row + 1, max_column], [0, 1])
  end

  protected

  def initialize(blizzards, max_row, max_column)
    @blizzards = blizzards
    @max_row = max_row
    @max_column = max_column
  end

  private

  def path_to(start, destination)
    choices = [start]

    count = 1
    loop do
      blizzard_locations = blizzards.map(&:move).to_set
      choices = choices.flat_map { |row, column| move_expedition(row, column) }.to_set
      break if choices.include? destination

      choices -= blizzard_locations
      count += 1
    end
    count
  end

  def move_expedition(row, column)
    choices = [[row, column]]
    choices << [row - 1, column] if row > 1 || (column == 1 && row == 1)
    choices << [row + 1, column] if row < max_row || (column == max_column && row == max_row)
    choices << [row, column - 1] if column > 1 && row.positive? && row <= max_row
    choices << [row, column + 1] if column < max_column && row.positive? && row <= max_row
    choices
  end

  attr_reader :blizzards, :max_row, :max_column
end

basin = Basin.create
path_to_exit = basin.path_to_exit
pp path_to_exit

round_trip = [path_to_exit, basin.path_to_entrance, basin.path_to_exit]
pp round_trip.sum
