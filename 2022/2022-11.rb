lines = File.read("2022/data/2022-11.data", chomp: true)
monkey_lines = lines.split("\n\n")

class Monkey
  def self.create(line)
    lines = line.split("\n")
    items = *lines[1].scan(/\d+/).map(&:to_i)
    operation = lines[2].split("= ").last
    modulo = lines[3].scan(/\d+/).first.to_i
    if_true = lines[4].scan(/\d+/).first.to_i
    if_false = lines[5].scan(/\d+/).first.to_i
    new(items, operation, modulo, if_true, if_false)
  end

  def throw
    thrown = items.map do |item|
      level = eval(operation.gsub("old", item.to_s)) / 3
      monkey = (level % modulo).zero? ? if_true : if_false
      [monkey, level]
    end
    @inspected += items.size
    @items = []
    thrown
  end

  def throw_with_worry(mod)
    thrown = items.map do |item|
      level = eval(operation.gsub("old", item.to_s))
      monkey = (level % modulo).zero? ? if_true : if_false
      [monkey, level % mod]
    end
    @inspected += items.size
    @items = []
    thrown
  end

  def receive(item)
    items << item
  end

  attr_reader :inspected, :modulo

  def to_s
    items.inspect
  end

  protected

  def initialize(items, operation, modulo, if_true, if_false)
    @items = items
    @operation = operation
    @modulo = modulo
    @if_true = if_true
    @if_false = if_false
    @inspected = 0
  end

  private

  attr_reader :items, :operation, :if_true, :if_false
end

monkeys = monkey_lines.map { Monkey.create _1 }

20.times do
  monkeys.each do |monkey|
    monkey.throw.each do |index, item|
      monkeys[index].receive(item)
    end
  end
end

pp monkeys.map(&:inspected).max(2).reduce(:*)

monkeys = monkey_lines.map { Monkey.create _1 }
modulo = monkeys.map(&:modulo).reduce(&:*)

10_000.times do |time|
  monkeys.each do |monkey|
    monkey.throw_with_worry(modulo).each do |index, item|
      monkeys[index].receive(item)
    end
  end
end

pp monkeys.map(&:inspected).max(2).reduce(:*)
