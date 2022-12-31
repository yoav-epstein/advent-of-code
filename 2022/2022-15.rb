class Sensor
  def initialize(sensor_x, sensor_y, beacon_x, beacon_y)
    @sensor_x = sensor_x
    @sensor_y = sensor_y
    @beacon_x = beacon_x
    @beacon_y = beacon_y
  end

  attr_reader :sensor_x, :sensor_y, :beacon_x, :beacon_y

  def on_line(y)
    distance_to_line = (y - sensor_y).abs
    squares = distance - distance_to_line
    return if squares.negative?

    sensor_x - squares..sensor_x + squares
  end

  def beacon_on_line?(y)
    beacon_y == y
  end

  private

  def distance
    @distance ||= (sensor_x - beacon_x).abs + (sensor_y - beacon_y).abs
  end

  def min_y
    sensor_y - distance
  end

  def max_y
    sensor_y + distance
  end
end

class Grid
  def self.parse
    grid = new
    lines = File.readlines("2022/data/2022-15.data", chomp: true)
    lines.each do |line|
      grid << Sensor.new(*line.match(/x=(\d+).*y=(\d+).*x=(-*\d+).*y=(-*\d+)/).captures.map(&:to_i))
    end
    grid
  end

  def <<(sensor)
    sensors << sensor
  end

  def coverage(y)
    on_line(y).map(&:size).sum - beacons(y).size
  end

  def lost_beacon
    # y = 3349056
    y = 4_000_000.times do |y|
      print "." if (y % 100_000).zero?
      break y if on_line(y).size > 1
    end
    puts ""
    x = on_line(y).first.last + 1
    x * 4_000_000 + y
  end

  protected

  def initialize
    @sensors = []
  end

  private

  attr_reader :sensors

  def on_line(y)
    on_line = sensors.map do |sensor|
      sensor.on_line(y)
    end.compact
    reduce_ranges(on_line)
  end

  def reduce_ranges(ranges)
    sorted_ranges = ranges.sort_by(&:first)
    sorted_ranges.reduce([sorted_ranges.first]) do |final, range2|
      range1 = final.shift
      if range1.last < range2.first
        final + [range1, range2]
      else
        final + [range1.first..[range1.last, range2.last].max]
      end
    end
  end

  def beacons(y)
    sensors.select { _1.beacon_on_line? y }.map(&:beacon_x).uniq
  end
end

grid = Grid.parse

pp grid.coverage(2_000_000)

pp grid.lost_beacon
