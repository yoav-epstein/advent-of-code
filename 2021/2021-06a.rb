input = File.readlines('2021/2021-06.data', chomp: true)

ages = input[0].split(',').map(&:to_i)

p ages

class LanternFish
  @fish = []

  def self.create(age)
    @fish << new(age)
  end

  def self.count
    @fish.size
  end

  def self.advance
    @fish.each(&:advance)
  end

  def self.print
    @fish.map(&:age)
  end

  attr_reader :age

  def initialize(age)
    @age = age
  end

  def advance
    if age == 0
      @age = 6
      LanternFish.create(9)
    else
      @age -= 1
    end
  end
end

ages.each do |age|
  LanternFish.create(age)
end


256.times do |i|
  LanternFish.advance
  p i
  # p LanternFish.print
end

p LanternFish.count
