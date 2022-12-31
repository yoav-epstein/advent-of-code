class Jet
  include Enumerable

  def self.create
    jets = File.read("2022/data/2022-17.data").strip
    new(jets)
  end

  def each
    Enumerator.new do |yielder|
      loop do
        yielder << jets[position]
        self.position = (position + 1) % size
      end
    end
  end

  attr_reader :size

  protected

  def initialize(jets)
    @jets = jets
    @size = jets.size
    @position = 0
  end

  private

  attr_reader :jets
  attr_accessor :position
end

class Rock
  include Enumerable

  ROCK1 = [[1, 1, 1, 1]].freeze
  ROCK2 = [[0, 1, 0], [1, 1, 1], [0, 1, 0]].freeze
  ROCK3 = [[0, 0, 1], [0, 0, 1], [1, 1, 1]].freeze
  ROCK4 = [[1], [1], [1], [1]].freeze
  ROCK5 = [[1, 1], [1, 1]].freeze
  ROCKS = [ROCK1, ROCK2, ROCK3, ROCK4, ROCK5].freeze

  def initialize
    @position = 0
    @size = ROCKS.size
  end

  def each
    Enumerator.new do |yielder|
      loop do
        yielder << ROCKS[position]
        self.position = (position + 1) % size
      end
    end
  end

  private

  attr_reader :size
  attr_accessor :position
end

class Tunnel
  def initialize
    @tunnel = [empty_row, empty_row, empty_row]
  end

  def height_large(height)
    offset, size = cycle
    height_in_cycle = heights[offset + size] - heights[offset]
    cycles, remainder = (height - offset).divmod size

    heights[offset + remainder - 1] + cycles * height_in_cycle
  end

  def height(height)
    heights[height - 1]
  end

  def print
    tunnel.each do |t|
      row = t.map { |v| v.zero? ? " " : "#" }
      puts "|#{row.join('')}|"
    end
  end

  private

  attr_reader :tunnel

  def heights
    @heights ||= 5000.times.map do
      drop_rock
      tunnel.size - 3
    end
  end

  def drop_rock
    rock = rocks.next
    width = rock.first.size

    row = 0
    col = 2
    rock.reverse.each do |rock_row|
      tunnel.unshift [0] * col + rock_row + [0] * (7 - col - width)
    end
    loop do
      jet = jets.next
      col = if jet == "<"
              push_left(rock, row, col)
            else
              push_right(rock, row, col)
            end
      break if push_down(rock, row, col) == row

      row += 1
    end

    tunnel.shift while tunnel[3].all?(&:zero?)
  end

  def push_right(rock, row, col)
    return col if rock.first.size + col >= 7

    toggle(rock, row, col)
    toggle(rock, row, col + 1)

    if collision?(rock, row, col + 1)
      toggle(rock, row, col + 1)
      toggle(rock, row, col)
      col
    else
      col + 1
    end
  end

  def push_left(rock, row, col)
    return col if col.zero?

    toggle(rock, row, col)
    toggle(rock, row, col - 1)

    if collision?(rock, row, col - 1)
      toggle(rock, row, col - 1)
      toggle(rock, row, col)
      col
    else
      col - 1
    end
  end

  def push_down(rock, row, col)
    return row if row + rock.size >= tunnel.size

    toggle(rock, row, col)
    toggle(rock, row + 1, col)

    if collision?(rock, row + 1, col)
      toggle(rock, row + 1, col)
      toggle(rock, row, col)
      row
    else
      row + 1
    end
  end

  def toggle(rock, row, col)
    rock.each_with_index do |rock_row, row_index|
      rock_row.each_with_index do |v, col_index|
        tunnel[row + row_index][col + col_index] ^= v
      end
    end
  end

  def collision?(rock, row, col)
    0.upto(rock.size - 1).any? do |rock_row|
      0.upto(rock.first.size - 1).any? do |rock_col|
        tunnel[row + rock_row][col + rock_col].zero? if rock[rock_row][rock_col] == 1
      end
    end
  end

  def empty_row
    Array.new(7) { 0 }
  end

  def jets
    @jets ||= Jet.create.each
  end

  def rocks
    @rocks ||= Rock.new.each
  end

  def height_deltas
    @height_deltas ||= heights.each_cons(2).map {_2 - _1 }
  end

  def height_deltas_size
    @height_deltas_size ||= height_deltas.size
  end

  def cycle
    0.upto(height_deltas_size / 2) do |offset|
      1.upto(height_deltas_size / 2) do |size|
        return [offset, size] if cycle_at?(offset, size)
      end
    end
  end

  def cycle_at?(offset, size)
    size.times.all? do |index|
      (offset + index + size...height_deltas_size).step(size).all? do |position|
        height_deltas[offset + index] == height_deltas[position]
      end
    end
  end
end

tunnel = Tunnel.new
pp tunnel.height(2022)
pp tunnel.height_large(1_000_000_000_000) # 1560919540245
