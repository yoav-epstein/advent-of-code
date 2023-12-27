require_relative "../input"

class Parse
  def initialize(words: true, test: false)
    @words = words
    @test = test
  end

  def data
    numbers.map do |num|
      num[0] * 10 + num[-1]
    end
  end

  private

  def numbers
    input.readlines.map do |line|
      0.upto(line.length - 1).map do |pos|
        @words? parse_with_words(line, pos) : parse(line, pos)
      end.compact
    end
  end

  def parse(line, pos)
    line[pos].to_i if line[pos] >= "0" && line[pos] <= "9"
  end

  def parse_with_words(line, pos)
    if line[pos] >= "0" && line[pos] <= "9"
      line[pos].to_i
    elsif line[pos, 3] == "one"
      1
    elsif line[pos, 3] == "two"
      2
    elsif line[pos, 5] == "three"
      3
    elsif line[pos, 4] == "four"
      4
    elsif line[pos, 4] == "five"
      5
    elsif line[pos, 3] == "six"
      6
    elsif line[pos, 5] == "seven"
      7
    elsif line[pos, 5] == "eight"
      8
    elsif line[pos, 4] == "nine"
      9
    end
  end

  def input
    Input.new(2023, 1, test: @test)
  end
end

pp Parse.new(words: false).data.sum

pp Parse.new.data.sum
