class MonkeyYell
  def self.create
    lines = File.readlines("2022/data/2022-21.data", chomp: true)
    new lines
  end

  def human!
    redefine_root

    offset = 1
    loop do
      redefine_humn(offset)
      if root.positive?
        offset *= 10
      else
        offset /= 10
        break
      end
    end

    guess = 0
    loop do
      guess += offset
      redefine_humn(guess)
      break if root.zero?

      if root.negative?
        guess -= offset
        offset /= 10
      end
    end

    guess
  end

  protected

  def initialize(methods)
    methods.each do |method|
      name, code = *method.split(": ")
      self.class.define_method(name) { instance_eval code }
      @root_code = code if name == "root"
    end
  end

  private

  attr_reader :root_code

  def redefine_root
    a, b = root_code.scan(/\w+/)
    self.class.define_method("root") { instance_eval "#{a} - #{b}" }
  end

  def redefine_humn(value)
    self.class.define_method("humn") { value }
  end
end

monkey_yell = MonkeyYell.create
pp monkey_yell.root
pp monkey_yell.human!
