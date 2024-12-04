require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def robots
    input.readlines.map do |line|
      line.scan(/-?\d+/).map(&:to_i)
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

class Motion
  def initialize(robots, max_x, max_y)
    @robots = robots
    @max_x = max_x
    @max_y = max_y
  end

  def simulate(moves)
    @robots = robots.map do |robot|
      x, y, dx, dy = robot
      x = (x + dx * moves) % max_x
      y = (y + dy * moves) % max_y
      [x, y, dx, dy]
    end
  end

  def safety_factor
    counts = Hash.new(0)
    robots.each do |robot|
      x, y = robot
      next if x == max_x / 2 || y == max_y / 2

      if x < max_x / 2
        if y < max_y / 2
          counts[:top_left] += 1
        else
          counts[:bottom_left] += 1
        end
      elsif y < max_y / 2
        counts[:top_right] += 1
      else
        counts[:bottom_right] += 1
      end
    end

    counts.values.reduce(:*)
  end

  def tree?
    count, prev_x, prev_y = 0
    sorted_robots.each do |robot|
      x, y = robot
      if y == prev_y
        if x == prev_x + 1
          count += 1
        elsif x != prev_x
          count = 0
        end
      else
        count = 0
      end
      prev_x = x
      prev_y = y

      return true if count > 5
    end
    false
  end

  def map
    0.upto(max_y - 1) do |y|
      0.upto(max_x - 1) do |x|
        count = robots.count do |robot|
          robot[0] == x && robot[1] == y
        end
        print count.positive? ? count : "."
      end
      puts
    end
    puts
  end

  private

  attr_reader :robots, :max_x, :max_y

  def sorted_robots
    robots.sort do |a, b|
      if a[1] == b[1]
        a[0] <=> b[0]
      else
        a[1] <=> b[1]
      end
    end
  end
end

# parse = Parse.new(test: true)
# motion = Motion.new(parse.robots, 11, 7)
#
parse = Parse.new
motion = Motion.new(parse.robots, 101, 103)

motion.simulate(100)
pp motion.safety_factor

index = 100
loop do
  index += 1
  motion.simulate(1)
  next unless motion.tree?

  pp index
  break
end

# motion.map
