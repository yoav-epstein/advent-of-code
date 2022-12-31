require 'forwardable'

class Nodes
  include Enumerable
  extend Forwardable

  def_delegator :@list, :each

  def initialize
    @list = []
  end

  def find(name)
    @list.find { |node| node.name == name }
  end

  def add(node)
    @list << node
    node
  end

  attr_reader :list
end

class Node
  def initialize(name, orbits = nil)
    @name = name
    @orbits = orbits
    @distance = 0 if name == 'COM'
  end

  attr_reader :name
  attr_accessor :orbits

  def distance
    @distance ||= 1 + orbits.distance
  end
end

input = File.read('2019/2019-06.data')
orbits = input.split("\n").map { |orbit| orbit.split(')') }

nodes = Nodes.new
orbits.each do |a, b|
  orbits = nodes.find(a) || nodes.add(Node.new(a))
  node = nodes.find(b) || nodes.add(Node.new(b))
  node.orbits = orbits
end

pp nodes.map(&:distance).sum
