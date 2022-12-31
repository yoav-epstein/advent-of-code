require "set"

lines = File.readlines("2022/data/2022-14.data", chomp: true)

class Cave
  def initialize
    @rocks = Set.new
    @max_y = 0
  end

  def trace(lines)
    traces = lines.map do |line|
      line.scan(/\d+,\d+/).map do |pair|
        pair.split(",").map(&:to_i)
      end
    end
    traces.each do |trace|
      trace.each_cons(2) do |start, finish|
        trace_line(start, finish)
      end
    end
  end

  def simulate
    @sand = Set.new
    while drop_sand
    end
    @sand.size - 1
  end

  def simulate_with_floor
    @sand = Set.new
    self.max_y += 1
    drop_sand until sand.include?("500,0")
    @sand.size
  end

  private

  attr_reader :rocks, :sand
  attr_accessor :max_y

  def drop_sand
    x = 500
    y = 0
    while y < max_y
      if space?(x, y + 1)
        y += 1
      elsif space?(x - 1, y + 1)
        x -= 1
        y += 1
      elsif space?(x + 1, y + 1)
        x += 1
        y += 1
      else
        sand << "#{x},#{y}"
        return true
      end
    end
    sand << "#{x},#{y}"
    false
  end

  def space?(x, y)
    position = "#{x},#{y}"
    !rocks.include?(position) && !sand.include?(position)
  end

  def trace_line(start, finish)
    if start.first == finish.first
      trace_vertical_line(start.last, finish.last, start.first)
    else
      trace_horizontal_line(start.first, finish.first, start.last)
    end
  end

  def trace_horizontal_line(x1, x2, y)
    x1, x2 = [x1, x2].sort

    x1.upto(x2) { rocks << "#{_1},#{y}" }
    self.max_y = y if y > max_y
  end

  def trace_vertical_line(y1, y2, x)
    y1, y2 = [y1, y2].sort
    y1.upto(y2) { rocks << "#{x},#{_1}" }
    self.max_y = y2 if y2 > max_y
  end
end

cave = Cave.new
cave.trace lines
pp cave.simulate
pp cave.simulate_with_floor
