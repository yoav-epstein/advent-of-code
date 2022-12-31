lines = File.readlines("2022/data/2022-10.data", chomp: true)

class Calculator
  def initialize
    @x = 1
    @time = 0
    @history = []
    tick
  end

  def execute(instruction)
    if instruction == "noop"
      noop
    else
      addx instruction[5..].to_i
    end
  end

  def signal_strength
    [20, 60, 100, 140, 180, 220].map { _1 * history[_1] }.sum
  end

  def draw
    history.shift
    history.each_slice(40) do |h|
      line = h.map.with_index do |x, position|
        overlap?(x, position) ? "@@" : "  "
      end
      puts line.join
    end
  end

  def overlap?(x, position)
    (x - 1..x + 1).include? position
  end

  def print_history
    history.each_with_index do |x, i|
      puts "%3d - %d" % [i, x]
    end
    puts "%3d - %d" % [history.size, x]
  end

  private

  attr_accessor :x, :time
  attr_reader :history

  def noop
    tick
  end

  def addx(value)
    tick
    tick
    self.x += value
  end

  def tick
    history[time] = x
    self.time += 1
  end
end

calculator = Calculator.new
lines.each { calculator.execute _1 }

pp calculator.signal_strength

calculator.draw
