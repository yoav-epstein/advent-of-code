lines = File.read("2022/data/2022-13.data").split("\n\n")

pairs = lines.map { _1.split("\n").map &method(:eval) }

class Packet
  include Comparable

  def initialize(list)
    @list = list
  end

  attr_reader :list

  def <=>(other)
    compare(list, other.list)
  end

  private

  def compare(left, right)
    if left.nil?
      -1
    elsif right.nil?
      1
    elsif left.is_a?(Integer)
      if right.is_a?(Integer)
        return nil if left == right

        left <= right ? -1 : 1
      else
        compare([left], right)
      end
    elsif right.is_a?(Integer)
      compare(left, [right])
    else
      0.upto(left.size - 1).each do |index|
        c = compare(left[index], right[index])
        return c unless c.nil?
      end
      return -1 if left.size < right.size
      return nil if left.last == right.last
      compare(left.last, right.last)
    end
  end
end

indexes = pairs.map.with_index do |pair, index|
  index + 1 if Packet.new(pair[0]) < Packet.new(pair[1])
end

pp indexes.compact.sum

packets = pairs.flat_map do |left, right|
  [Packet.new(left), Packet.new(right)]
end

sorted = (packets + [Packet.new([[2]]), Packet.new([[6]])]).sort

lists = sorted.map(&:list)

i2 = lists.index([[2]]) + 1
i6 = lists.index([[6]]) + 1

puts i2 * i6
