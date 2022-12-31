class Base5
  DECIMAL = {
    "0" => 0,
    "1" => 1,
    "2" => 2,
    "-" => -1,
    "=" => -2
  }.freeze

  def self.parse(string)
    mult = 1
    value = 0
    string.reverse.each_char do |digit|
      value += DECIMAL[digit] * mult
      mult *= 5
    end
    new value
  end

  def initialize(value)
    @value = value
  end

  def to_i
    value
  end

  def to_b5
    divisor = value
    b5 = []
    while divisor.positive?
      divisor, remainder = divisor.divmod 5
      case remainder
      when 3
        divisor += 1
        b5.unshift "="
      when 4
        divisor += 1
        b5.unshift "-"
      else
        b5.unshift remainder
      end
    end

    b5.join ""
  end

  private

  attr_reader :value
end

lines = File.readlines("2022/data/2022-25.data", chomp: true)
base5s = lines.map { Base5.parse _1 }
sum = base5s.map(&:to_i).sum
pp Base5.new(sum).to_b5
