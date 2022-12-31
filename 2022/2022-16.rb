require "set"

class Node
  def initialize(name, rate, connections)
    @name = name
    @rate = rate
    @connections = connections
  end

  attr_reader :name, :rate, :connections
end

class Cave
  def self.create
    nodes = File.readlines("2022/data/2022-16.data", chomp: true).map do |line|
      name, rate = *line.match(/Valve (\w\w).*rate=(\d+)/).captures
      connections = line.split("to valve").last[1..].lstrip.split(", ")
      Node.new(name, rate.to_i, connections)
    end

    new(nodes)
  end

  def release_pressure
    pressures(30).max
  end

  def release_elephant
    @pressures = nil
    pressures.max(500).combination(2).map do |human, elephant|
      combine(human, elephant)
    end.max
  end

  protected

  def initialize(nodes)
    @nodes = nodes.map { |node| [node.name, node] }.to_h
    @distances = {}
  end

  private

  attr_reader :nodes, :distances

  def pressures(time = 26)
    @pressures ||= calculate_pressures("AA", nodes_with_rate.keys, time, 0, ["AA"], [])
  end

  def calculate_pressures(prev_name, names, time, pressure, path, pressures)
    extra = time * nodes[prev_name].rate
    return [[pressure + extra] + path + pressures + [extra]] if names.empty?

    choices = names.map { |name| [time - distance(prev_name, name) - 1, name] }.select { |time_left, _name| time_left.positive? }
    return [[pressure + extra] + path + pressures + [extra]] if choices.empty?

    choices.flat_map do |time_left, name|
      calculate_pressures(name, names - [name], time_left, pressure + extra, path + [name], pressures + [extra])
    end
  end

  def nodes_with_rate
    @nodes_with_rate = nodes.select { |_, node| node.rate.positive? }
  end

  def combine(human, elephant)
    nodes = human.select { |v| v.is_a?(String) } | elephant.select { |v| v.is_a?(String) }
    human_offset = human.index(0) - 1
    elephant_offset = elephant.index(0) - 1
    pressure = nodes.map do |node|
      human_index = human.index(node)
      elephant_index = elephant.index(node)
      human_value = human_index ? human[human_index + human_offset] : 0
      elephant_value = elephant_index ? elephant[elephant_index + elephant_offset] : 0
      human_value > elephant_value ? human_value : elephant_value
    end.sum
    [pressure, human, elephant]
  end

  def distance(from, to)
    key = "#{from}-#{to}"
    return distances[key] if distances[key]

    distances[key] = traverse(from, to)
  end

  def traverse(from, to)
    list = [[from, 0]]
    visited = Set.new

    loop do
      name, distance = *list.shift
      return distance if name == to
      next if visited.include? name

      nodes[name].connections.each do |connection|
        list << [connection, distance + 1]
      end

      visited << name
    end
  end
end

cave = Cave.create
pp cave.release_pressure.first
pp cave.release_elephant.first
