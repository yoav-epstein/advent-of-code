require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def map
    @map ||= input.readlines.map do |line|
      line.chomp.chars
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

class Map
  def initialize(map)
    @map = map.map(&:dup)
    @rows = @map.size
    @cols = @map[0].size
    @max_moves = @rows * @cols
    @moves = 0
    @locations = 1
    find_guard
  end

  def run
    loop do
      next if move_guard

      break @moves > max_moves ? nil : @locations
    end
  end

  def location_map
    map.map(&:dup).tap do |new_map|
      new_map[@guard_initial_row][@guard_initial_col] = "^"
    end
  end

  private

  attr_reader :map, :rows, :cols, :max_moves

  def move_guard
    next_row = @guard_row + guard_offsets[@guard_offsets_index][0]
    next_col = @guard_col + guard_offsets[@guard_offsets_index][1]

    return if next_row.negative? || next_col.negative? || next_row >= rows || next_col >= cols
    return if @moves > max_moves

    case map[next_row][next_col]
    when "."
      map[next_row][next_col] = "X"
      @guard_row = next_row
      @guard_col = next_col
      @locations += 1
      @moves += 1
    when "X"
      @guard_row = next_row
      @guard_col = next_col
      @moves += 1
    when "#"
      @guard_offsets_index = (@guard_offsets_index + 1) % 4
    end

    true
  end

  def find_guard
    0.upto(rows - 1) do |row|
      0.upto(cols - 1) do |col|
        next unless map[row][col] == "^"

        map[row][col] = "X"
        @guard_initial_row = @guard_row = row
        @guard_initial_col = @guard_col = col
        @guard_offsets_index = 0
        break
      end
    end
  end

  def guard_offsets
    @guard_offsets ||= [
      [-1, 0],
      [0, 1],
      [1, 0],
      [0, -1]
    ]
  end
end

class LoopFinder
  def initialize(parse_map)
    @parse_map = parse_map
    @rows = parse_map.size
    @cols = parse_map[0].size

  end

  def place_obstacle
    locations = 0

    0.upto(rows - 1) do |row|
      print "\r[rows #{rows - row}, locations #{locations}]"

      0.upto(cols - 1) do |col|
        next unless parse_map[row][col] == "X"

        new_map = parse_map.map(&:dup)
        new_map[row][col] = "#"

        locations += 1 if Map.new(new_map).run.nil?
      end
    end
    print "\r"

    locations
  end

  private

  attr_reader :parse_map, :rows, :cols
end

parse = Parse.new(test: false)

map = Map.new(parse.map)
pp map.run

pp LoopFinder.new(map.location_map).place_obstacle
