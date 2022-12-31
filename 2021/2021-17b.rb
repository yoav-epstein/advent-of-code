class Probe
  def initialize
    input = File.read('2021/2021-17.data')
    vals = *input.chomp.scan(/x=(\d+)..(\d+), y=(.*)\.\.(.*)/)[0]
    @x_min, @x_max, @y_min, @y_max = *(vals.map(&:to_i))
  end

  def count
    total = 0
    1.upto(x_max) do |vx|
      y_min.upto(200) do |vy|
        # puts "simulate #{vx}, #{vy}"
        total += 1 if simulate(vx, vy)
      end
    end
    total
  end

  private

  attr_reader :x_min, :x_max, :y_min, :y_max

  def simulate(start_vx, start_vy)
    x = 0
    y = 0
    vx = start_vx
    vy = start_vy
    while y >= y_min && x <= x_max
      return false if vx == 0 && x < x_min

      # puts "x = #{x} (#{vx}), y = #{y} (#{vy})"
      x += vx
      vx -= 1 if vx > 0
      y += vy
      vy -= 1
      if y >= y_min && y <= y_max && x >= x_min && x <= x_max
        puts "hit start_vx = #{start_vx}, start_vy = #{start_vy}"
        return true
      end
    end

    false
  end
end

p Probe.new.count
