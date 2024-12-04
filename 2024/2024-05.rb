require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def rules
    @rules ||= data.first.map do |line|
      line.split("|").map(&:to_i)
    end
  end

  def pages_list
    @pages_list ||= data.last.map do |line|
      line.split(",").map(&:to_i)
    end.tap(&:shift)
  end

  private

  def data
    @data ||= input.readlines.map(&:chomp).slice_before(&:empty?).to_a
  end

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class Book
  def initialize(rules, pages_list)
    @rules = rules
    @pages_list = pages_list
  end

  def ordered_pages
    partition_pages.first
  end

  def reordered_pages
    partition_pages.last.map(&method(:sort))
  end

  private

  attr_reader :rules, :pages_list

  def partition_pages
    @partition_pages ||= pages_list.partition do |pages|
      pages == sort(pages)
    end
  end

  def sort(pages)
    pages.sort { |a, b| rules[[a, b]] }
  end
end

def sum_middle(list_pages)
  list_pages.map do |pages|
    pages[pages.size / 2]
  end.sum
end

parse = Parse.new(test: false)

rules = Hash.new(0)
parse.rules.map do |before, after|
  rules[[before, after]] = -1
  rules[[after, before]] = 1
end

book = Book.new(rules, parse.pages_list)

pp sum_middle(book.ordered_pages)
pp sum_middle(book.reordered_pages)
