class MonkeyMap
  DIRECTIONS = %i[right down left up].freeze

  def self.create
    lines = File.read("2022/data/2022-22.data")
    map, path = lines.split("\n\n")
    new map, path
  end

  def follow_path
    self.row = 0
    self.column = map[row].index(".")
    self.direction = 0
    path.each(&method(:follow))
    password
  end

  protected

  def initialize(map, path)
    @map = map.each_line(chomp: true).to_a
    @path = path.gsub("R", "\nR\n").gsub("L", "\nL\n").each_line(chomp: true).to_a
    @columns = @map.map(&:size).max
    @rows = @map.size
  end

  private

  def password
    (row + 1) * 1000 + (column + 1) * 4 + direction
  end

  def follow(command)
    case command
    when "R"
      self.direction = (direction + 1) % 4
    when "L"
      self.direction = (direction - 1) % 4
    else
      command.to_i.times { move }
    end
  end

  def move
    case DIRECTIONS[direction]
    when :right
      move_column(1)
    when :down
      move_row(1)
    when :left
      move_column(-1)
    when :up
      move_row(-1)
    end
  end

  def move_row(offset)
    check_row = row
    loop do
      check_row = next_row(offset, check_row)
      case map[check_row][column]
      when "#"
        break
      when "."
        self.row = check_row
        break
      end
    end
  end

  def next_row(offset, row)
    row += offset
    row = rows - 1 if row.negative?
    row = 0 if row >= rows

    row
  end

  def move_column(offset)
    check_column = column
    loop do
      check_column = next_column(offset, check_column)
      case map[row][check_column]
      when "#"
        break
      when "."
        self.column = check_column
        break
      end
    end
  end

  def next_column(offset, column)
    column += offset
    column = columns - 1 if column.negative?
    column = 0 if column >= columns

    column
  end

  attr_reader :map, :columns, :rows, :path
  attr_accessor :row, :column, :direction
end

class MonkeyCube < MonkeyMap
  CUBE_FACES = [
    [nil, 1, 2],
    [nil, 3, nil],
    [4, 5, nil],
    [6, nil, nil]
  ].freeze

  protected

  def initialize(map, path)
    super
    @cube_size = @map.map { |row| row.strip.size }.min
    @cube = false
  end

  private

  attr_reader :cube_size

  def move
    next_row, next_column, next_direction = *next_position
    return if map[next_row][next_column] == "#"

    self.row = next_row
    self.column = next_column
    self.direction = next_direction
  end

  def right
    0
  end

  def down
    1
  end

  def left
    2
  end

  def up
    3
  end

  def face
    CUBE_FACES[row / cube_size][column / cube_size]
  end

  def row_on_face
    row - min_row_for(face)
  end

  def column_on_face
    column - min_column_for(face)
  end

  def min_row_for(face)
    [
      0,
      0,
      1 * cube_size,
      2 * cube_size,
      2 * cube_size,
      3 * cube_size
    ][face - 1]
  end

  def max_row_for(face)
    [
      1 * cube_size,
      1 * cube_size,
      2 * cube_size,
      3 * cube_size,
      3 * cube_size,
      4 * cube_size
    ][face - 1] - 1
  end

  def min_column_for(face)
    [
      1 * cube_size,
      2 * cube_size,
      1 * cube_size,
      0,
      1 * cube_size,
      0
    ][face - 1]
  end

  def max_column_for(face)
    [
      2 * cube_size,
      3 * cube_size,
      2 * cube_size,
      1 * cube_size,
      2 * cube_size,
      1 * cube_size
    ][face - 1] - 1
  end

  def next_position
    case DIRECTIONS[direction]
    when :right
      next_right
    when :down
      next_down
    when :left
      next_left
    when :up
      next_up
    end
  end

  def next_right
    return [row, column + 1, direction] if column < max_column_for(face)

    case face
    when 1 # => 2
      [row, column + 1, direction]
    when 2 # => 5
      [max_row_for(5) - row_on_face, max_column_for(5), left]
    when 3 # => 2
      [max_row_for(2), min_column_for(2) + row_on_face, up]
    when 4 # => 5
      [row, column + 1, direction]
    when 5 # => 2
      [max_row_for(2) - row_on_face, max_column_for(2), left]
    when 6 # => 5
      [max_row_for(5), min_column_for(5) + row_on_face, up]
    end
  end

  def next_down
    return [row + 1, column, direction] if row < max_row_for(face)

    case face
    when 1 # => 3
      [row + 1, column, direction]
    when 2 # => 3
      [min_row_for(3) + column_on_face, max_column_for(3), left]
    when 3 # => 5
      [row + 1, column, direction]
    when 4 # => 6
      [row + 1, column, direction]
    when 5 # => 6
      [min_row_for(6) + column_on_face, max_column_for(6), left]
    when 6 # => 2
      [min_row_for(2), min_column_for(2) + column_on_face, down]
    end
  end

  def next_left
    return [row, column - 1, direction] if column > min_column_for(face)

    case face
    when 1 # => 4
      [max_row_for(4) - row_on_face, min_column_for(4), right]
    when 2 # => 1
      [row, column - 1, direction]
    when 3 # => 4
      [min_row_for(4), min_column_for(4) + row_on_face, down]
    when 4 # => 1
      [max_row_for(1) - row_on_face, min_column_for(1), right]
    when 5 # => 4
      [row, column - 1, direction]
    when 6 # => 1
      [min_row_for(1), min_column_for(1) + row_on_face, down]
    end
  end

  def next_up
    return [row - 1, column, direction] if row > min_row_for(face)

    case face
    when 1 # => 6
      [min_row_for(6) + column_on_face, min_column_for(6), right]
    when 2 # => 6
      [max_row_for(6), min_column_for(6) + column_on_face, up]
    when 3 # => 1
      [row - 1, column, direction]
    when 4 # => 3
      [min_row_for(3) + column_on_face, min_column_for(3), right]
    when 5 # => 3
      [row - 1, column, direction]
    when 6 # => 4
      [row - 1, column, direction]
    end
  end
end

monkey_map = MonkeyMap.create
pp monkey_map.follow_path

monkey_cube = MonkeyCube.create
pp monkey_cube.follow_path
