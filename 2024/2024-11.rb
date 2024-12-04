require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def stones
    input.readlines.first.chomp.split
  end

  private

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class Blinker
  def initialize(stones)
    @stones = Hash.new(0).merge(stones.tally)
  end

  def blink
    stones.dup.each do |stone, count|
      if stone == "0"
        @stones["1"] += count
      elsif (length = stone.size).even?
        length /= 2
        stone1 = stone[0, length]
        stone2 = stone[length, length].to_i.to_s
        @stones[stone1] += count
        @stones[stone2] += count
      else
        @stones[(stone.to_i * 2024).to_s] += count
      end

      @stones[stone] -= count
    end
    @stones
  end

  def number_of_stones
    stones.values.sum
  end

  private

  attr_reader :stones
end

parse = Parse.new(test: false)
blinker = Blinker.new(parse.stones)

25.times { blinker.blink }
pp blinker.number_of_stones

50.times { blinker.blink }
pp blinker.number_of_stones
