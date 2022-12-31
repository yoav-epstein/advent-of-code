
class Node
  def initialize(value, previous_node)
    @value = value
    @previous_decrypted = previous_node
    @next_decrypted = nil
    @next_encrypted = nil
  end

  attr_reader :value
  attr_accessor :previous_decrypted, :next_decrypted, :next_encrypted
end

class Mixin
  def self.create(key = 1)
    lines = File.read("2022/data/2022-20.data")
    new(lines.scan(/-?\d+/).map(&:to_i).map { _1 * key})
  end

  def decrypt
    node = @list
    while node
      mixin(node)
      node = node.next_encrypted
    end
  end

  def decrypted_at(position)
    rotate = position % count
    rotate -= 1 if position.negative?
    node = zero_node
    rotate.times { node = node.next_decrypted }
    node
  end

  def decrypted
    node = zero_node
    count.times.map do
      node.value.tap { node = node.next_decrypted }
    end
  end

  protected

  def initialize(values)
    @list = @zero_node = previous_node = nil
    values.each do |value|
      node = Node.new(value, previous_node)
      previous_node&.next_decrypted = node
      previous_node&.next_encrypted = node
      previous_node = node
      @list ||= node
      @zero_node = node if value.zero?
    end
    previous_node.next_decrypted = @list
    @list.previous_decrypted = previous_node
    @count = values.size
  end

  private

  def mixin(node)
    rotate = node.value % (count - 1)
    return if rotate.zero?

    new_position = node
    rotate.times { new_position = new_position.next_decrypted }

    # remove
    node.previous_decrypted.next_decrypted = node.next_decrypted
    node.next_decrypted.previous_decrypted = node.previous_decrypted

    # update node
    node.previous_decrypted = new_position
    node.next_decrypted = new_position.next_decrypted

    # insert node
    node.previous_decrypted.next_decrypted = node
    node.next_decrypted.previous_decrypted = node
  end

  attr_reader :list, :zero_node, :count
end

mixin = Mixin.create
mixin.decrypt

pp [1000, 2000, 3000].map { mixin.decrypted_at(_1).value }.sum

mixin = Mixin.create(811_589_153)
10.times { mixin.decrypt }

pp [1000, 2000, 3000].map { mixin.decrypted_at(_1).value }.sum
