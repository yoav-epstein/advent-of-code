first = 128_392
last = 643_281

class Password
  def initialize(number)
    @number = number
  end

  def valid?
    monotonic? && duplicate? && twos?
  end

  private

  attr_reader :number

  def monotonic?
    numbers.sort == numbers
  end

  def duplicate?
    numbers.uniq != numbers
  end

  def twos?
    count = Hash.new(0)
    numbers.each do |digit|
      count[digit] += 1
    end
    count.values.any? { |v| v == 2 }
  end

  def numbers
    @numbers ||= number.to_s.chars
  end
end

valid = first.upto(last).select do |number|
  Password.new(number).valid?
end

pp valid.size
