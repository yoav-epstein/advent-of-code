require "set"

class Cube
  def self.create
    lines = File.readlines "2022/data/2022-18.data", chomp: true
    points = Set.new(lines.map { |line| line.split(",").map(&:to_i) })
    new points
  end

  def count_facets
    points.map(&method(:facets)).map(&:size).sum
  end

  def count_outer_facets
    color_outside
    points.map(&method(:outside_facets)).map(&:size).sum
  end

  protected

  def initialize(points)
    @points = points
    @outside_points = Set.new
  end

  private

  attr_reader :points, :outside_points

  def outside_facets(point)
    facets(point) & outside_points
  end

  def facets(point)
    faces = Set.new([
                      [point[0] - 1, point[1], point[2]],
                      [point[0] + 1, point[1], point[2]],
                      [point[0], point[1] - 1, point[2]],
                      [point[0], point[1] + 1, point[2]],
                      [point[0], point[1], point[2] - 1],
                      [point[0], point[1], point[2] + 1]
                    ])
    faces - points
  end

  def color_outside
    min[0].upto(max[0]) do |i0|
      min[1].upto(max[1]) do |i1|
        color(i0, i1, min[2])
        color(i0, i1, max[2])
      end
    end

    min[0].upto(max[0]) do |i0|
      min[2].upto(max[2]) do |i2|
        color(i0, min[1], i2)
        color(i0, max[1], i2)
      end
    end

    min[1].upto(max[1]) do |i1|
      min[2].upto(max[2]) do |i2|
        color(min[0], i1, i2)
        color(max[0], i1, i2)
      end
    end
  end

  def color(i0, i1, i2)
    return if i0 < min[0] || i0 > max[0]
    return if i1 < min[1] || i1 > max[1]
    return if i2 < min[2] || i2 > max[2]

    point = [i0, i1, i2]
    return if points.include? point
    return if outside_points.include? point

    outside_points << point

    color(i0 - 1, i1, i2)
    color(i0 + 1, i1, i2)
    color(i0, i1 - 1, i2)
    color(i0, i1 + 1, i2)
    color(i0, i1, i2 - 1)
    color(i0, i1, i2 + 1)
  end

  def max
    @max ||= points.to_a.transpose.map(&:max).map { _1 + 1 }
  end

  def min
    @min ||= points.to_a.transpose.map(&:min).map { _1 - 1 }
  end
end

cube = Cube.create

pp cube.count_facets

pp cube.count_outer_facets
