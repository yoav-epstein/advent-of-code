require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def scratchcards
    input.readlines.to_h do |line|
      card, numbers = line.split(":")
      [
        card.scan(/\d+/).first.to_i,
        numbers.split("|").map do |part|
          part.scan(/\d+/).map(&:to_i)
        end
      ]
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

class Scratchcard
  def initialize(card)
    @winnings = card[0]
    @plays = card[1]
  end

  def points
    matches.zero? ? 0 : 2**(matches - 1)
  end

  def matches
    @matches ||= (plays & winnings).size
  end

  private

  attr_reader :winnings, :plays
end

class Scratchcards
  def initialize(cards)
    @cards = cards
  end

  def points
    cards.values.sum do |card|
      Scratchcard.new(card).points
    end
  end

  def total
    count = Hash.new(0)
    matches.each do |card, matches|
      count[card] += 1
      matches.times { |offset| count[card + offset + 1] += count[card] }
    end
    count
  end

  private

  attr_reader :cards

  def matches
    cards.transform_values do |card|
      Scratchcard.new(card).matches
    end
  end
end

parse = Parse.new(test: false)
scratchcards = Scratchcards.new(parse.scratchcards)

pp scratchcards.points
pp scratchcards.total.values.sum
