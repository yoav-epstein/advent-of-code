require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
    parse
  end

  def list1
    parse.first
  end

  def list2
    parse.last
  end

  private

  def parse
    @parse ||= input.readlines.map do |line|
      line.split.map(&:to_i)
    end.transpose
  end

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

parse = Parse.new(test: false)

list1 = parse.list1.sort
list2 = parse.list2.sort

distances = list1.zip(list2).map do |a, b|
  (a - b).abs
end

pp distances.sum

tally1 = list1.tally
tally2 = list2.tally

similarities = tally1.map do |location, count|
  location * count * (tally2[location] || 0)
end

pp similarities.sum
