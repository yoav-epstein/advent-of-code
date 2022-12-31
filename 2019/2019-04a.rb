first = 128_392
last = 643_281

class Password
  def initialize(number)
    @number = number
  end

  def valid?
    monotonic? && duplicate?
  end

  private

  attr_reader :number

  def monotonic?
    numbers.sort == numbers
  end

  def duplicate?
    numbers.uniq != numbers
  end

  def numbers
    @numbers ||= number.to_s.chars
  end
end

valid = first.upto(last).select do |number|
  Password.new(number).valid?
end

pp valid
