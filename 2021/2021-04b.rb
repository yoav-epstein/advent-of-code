input = File.readlines('2021/2021-04.data', chomp: true)

numbers = input.first.split(',').map(&:to_i)

class Board
  def initialize
    @grid = []
    @rows = [[],[],[],[],[]]
    @cols = [[],[],[],[],[]]
    @won = false
  end

  def add_line(line)
    @grid += line.split(' ').map(&:to_i)
  end

  def add_number(number)
    return if @won
    index = grid.index(number)
    return unless index

    row = index / 5
    col = index % 5

    r = @rows[row]
    r[col] = 1
    if r.compact.size == 5
      @won = true
      return bingo_score * number
    end

    c = @cols[col]
    c[row] = 1
    if c.compact.size == 5
      @won = true
      bingo_score * number
    end
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
  boards.each do |board|
    bingo = board.add_number(number)
    puts bingo if bingo
  end
end

p bingo
