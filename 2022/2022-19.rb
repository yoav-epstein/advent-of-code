class Blueprint
  def self.create
    lines = File.readlines("2022/data/2022-19.data")
    lines.map do |line|
      new(*line.scan(/\d+/).map(&:to_i))
    end
  end

  attr_reader :id

  def cost_to_build(robot)
    case robot
    when :ore_robot
      [ore_robot_cost_in_ore, 0, 0]
    when :clay_robot
      [clay_robot_cost_in_ore, 0, 0]
    when :obsidian_robot
      [obsidian_robot_cost_in_ore, obsidian_robot_cost_in_clay, 0]
    when :geode_robot
      [geode_robot_cost_in_ore, 0, geode_robot_cost_in_obsidian]
    end
  end

  protected

  def initialize(id, ore, clay, obsidian_ore, obsidian_clay, geode_ore, geode_obsidian)
    @id = id
    @ore_robot_cost_in_ore = ore
    @clay_robot_cost_in_ore = clay
    @obsidian_robot_cost_in_ore = obsidian_ore
    @obsidian_robot_cost_in_clay = obsidian_clay
    @geode_robot_cost_in_ore = geode_ore
    @geode_robot_cost_in_obsidian = geode_obsidian
  end

  private

  attr_reader :ore_robot_cost_in_ore, :clay_robot_cost_in_ore, :obsidian_robot_cost_in_ore, :obsidian_robot_cost_in_clay,
              :geode_robot_cost_in_ore, :geode_robot_cost_in_obsidian
end

class Simulation
  BUILD_CHOICES = %i[ore_robot clay_robot obsidian_robot geode_robot].freeze

  def self.max_geodes(blueprint, minutes)
    BUILD_CHOICES.map do |build_next|
      new(blueprint, minutes).run(build_next)
    end.max
  end

  def initialize(blueprint, minutes)
    @blueprint = blueprint
    @minutes = minutes
    @minute = 1
    @building_robot = false
    @ore_robots = 1
    @clay_robots = 0
    @obsidian_robots = 0
    @geode_robots = 0
    @ores = 0
    @clays = 0
    @obsidians = 0
    @geodes = 0
  end

  def initialize_dup(source)
    @minute = source.minute.dup
    @building_robot = source.building_robot.dup
    @ore_robots = source.ore_robots.dup
    @clay_robots = source.clay_robots.dup
    @obsidian_robots = source.obsidian_robots.dup
    @geode_robots = source.geode_robots.dup
    @ores = source.ores.dup
    @clays = source.clays.dup
    @obsidians = source.obsidians.dup
    @geodes = source.geodes.dup
  end

  attr_reader :blueprint
  attr_accessor :ore_robots, :clay_robots, :obsidian_robots, :geode_robots,
                :build_next, :building_robot, :minutes, :minute, :ores, :clays, :obsidians, :geodes

  def print
    pp [@minute,
        [@ore_robots,
         @clay_robots,
         @obsidian_robots,
         @geode_robots],
        [@ores,
         @clays,
         @obsidians,
         @geodes]].inspect
  end

  def run(build_next, built = [])
    # puts "run with #{build_next}, minute = #{@minute}"
    self.build_next = build_next
    while minute <= minutes
      if building_robot
        finish_building_robot
        return build_choices.map do |build_choice|
          dup.run(build_choice, built + [minute - 1, build_next])
        end.max
      end
      start_building_robot
      collect_resources
      # print
      self.minute += 1
    end
    # puts "run with #{build_next}, out of time, geodes = #{geodes}"
    [geodes, built]
  end

  private

  def collect_resources
    self.ores += ore_robots
    self.clays += clay_robots
    self.obsidians += obsidian_robots
    self.geodes += geode_robots
  end

  def start_building_robot
    cost_ore, cost_clay, cost_obsidian = *blueprint.cost_to_build(build_next)
    return unless ores >= cost_ore && clays >= cost_clay && obsidians >= cost_obsidian

    self.ores -= cost_ore
    self.clays -= cost_clay
    self.obsidians -= cost_obsidian

    self.building_robot = true
  end

  def finish_building_robot
    case build_next
    when :ore_robot
      self.ore_robots += 1
    when :clay_robot
      self.clay_robots += 1
    when :obsidian_robot
      self.obsidian_robots += 1
    when :geode_robot
      self.geode_robots += 1
    end
    self.building_robot = false
  end

  def build_choices
    if minute > 22
      %i[obsidian_robot geode_robot]
    elsif ore_robots > 3
      %i[clay_robot obsidian_robot geode_robot]
    else
      BUILD_CHOICES
    end
  end
end

blueprints = Blueprint.create

geodes = blueprints.map do |blueprint|
  puts "simulating blueprint #{blueprint.id}"
  [blueprint, Simulation.max_geodes(blueprint, 24)]
end

# pp geodes

pp geodes.map { |blueprint, max_geodes| blueprint.id * max_geodes.first }.sum

geodes = blueprints.first(3).map do |blueprint|
  puts "simulating blueprint #{blueprint.id}"
  Simulation.max_geodes(blueprint, 32)
end

# pp geodes

pp geodes.map(&:first).reduce(&:*)
