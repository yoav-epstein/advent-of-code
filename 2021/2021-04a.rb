input = File.readlines('2021/2021-04.data', chomp: true)

numbers = input.first.split(',').map(&:to_i)

class Board
  def initialize
    @grid = []
    @rows = [[],[],[],[],[]]
    @cols = [[],[],[],[],[]]
  end

  def add_line(line)
    @grid += line.split(' ').map(&:to_i)
  end

  def add_number(number)
    index = grid.index(number)
    return unless index

    row = index / 5
    col = index % 5

    r = @rows[row]
    r[col] = 1
    return bingo_score * number if r.compact.size == 5

    c = @cols[col]
    c[row] = 1
    bingo_score * number if c.compact.size == 5
  end

  private

  attr_reader :grid

  def bingo_score
    @grid.map.with_index do |val, index|
      row = index / 5
      col = index % 5

      @rows[row][col] == 1 ? 0 : val
    end.sum
  end
end

boards = []
count = 0
board = nil
input[2..-1].each do |line|
  next if line.empty?

  if count == 0
    board = Board.new
    boards << board
  end
  board.add_line(line)

  count = (count + 1) % 5
end

bingo = nil
numbers.each do |number|
  puts number
  boards.each do |board|
    bingo = board.add_number(number)
    break if bingo
  end
  break if bingo
end

p bingo
