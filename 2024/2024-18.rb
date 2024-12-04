require "set"
require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def locations
    @locations ||= input.readlines.map do |line|
      line.scan(/\d+/).map(&:to_i)
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

class FallingBytes
  def initialize(locations, max, count)
    @locations = locations
    @max = max
    @corrupted = locations.shift(count).to_set
  end

  def shortest_path
    visited = Set.new
    queue = [[[0, 0], []]]
    loop do
      location, route = queue.shift
      break if location.nil?
      break route if location == [max, max]
      next if visited.include?(location)

      visited << location
      offsets.each do |x_offset, y_offset|
        next_x = location[0] + x_offset
        next_y = location[1] + y_offset
        next if next_x.negative? || next_y.negative? || next_x > max || next_y > max
        next if corrupted.include?([next_x, next_y])

        queue << [[next_x, next_y], route + [location]]
      end
    end
  end

  def unpassable_after
    path = shortest_path
    locations.each do |location|
      @corrupted << location
      if path.include?(location)
        path = shortest_path
        break location if path.nil?
      end
    end
  end

  private

  attr_reader :locations, :max, :corrupted

  def offsets
    @offsets ||= [[-1, 0], [1, 0], [0, -1], [0, 1]]
  end
end

test = false
max = test ? 6 : 70
count = test ? 12 : 1024

parse = Parse.new(test: false)
falling_bytes = FallingBytes.new(parse.locations, max, count)
pp falling_bytes.shortest_path.size
puts falling_bytes.unpassable_after.join(",")
