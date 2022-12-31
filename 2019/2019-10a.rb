class Vector
  def initialize(i, j)
    @i = i
    @j = j
  end

  attr_reader :i, :j

  def min
    gcd = i.gcd(j)
    return dup if gcd == 1

    Vector.new(@i / gcd, @j / gcd)
  end

  def ==(other)
    @i == other.i && @j == other.j
  end
end

class Asteroid
  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_reader :x, :y

  def vector_to(other)
    Vector.new(other.x - x, other.y - y)
  end

  def visible(asteroids)
    @visible ||= calculate_visible(asteroids)
  end

  private

  def calculate_visible(asteroids)
    vectors = min_vectors(asteroids).uniq { |v| [v.i, v.j] }
    vectors.count
  end

  def min_vectors(asteroids)
    asteroids.map do |asteroid|
      next if asteroid == self

      vector_to(asteroid).min
    end.compact
  end
end

grid = File.read('2019/2019-10.data')

asteroids = []
grid.split("\n").each.with_index do |row, y|
  row.chars.each.with_index do |col, x|
    asteroids << Asteroid.new(x, y) if col == '#'
  end
end

pp asteroids

max = asteroids.max do |a, b|
  a.visible(asteroids) <=> b.visible(asteroids)
end

pp max
