require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def equations
    @equations ||= input.readlines.map do |line|
      result, numbers = line.split(":")
      [result.to_i, numbers.split.map(&:to_i)]
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

class Equation
  def initialize(result, numbers)
    @result = result
    @numbers = numbers.dup
  end

  def solvable?
    number = @numbers.shift
    compute(number, @numbers)
  end

  private

  def compute(accumulator, numbers)
    return if accumulator > @result
    return accumulator == @result if numbers.empty?

    number = numbers.shift
    compute(accumulator + number, numbers.dup) ||
      compute(accumulator * number, numbers.dup)
  end
end

class EquationWithConcat
  def initialize(result, numbers)
    @result = result
    @numbers = numbers.dup
  end

  def solvable?
    number = @numbers.shift
    compute(number, @numbers)
  end

  private

  def compute(accumulator, numbers)
    return if accumulator > @result
    return accumulator == @result if numbers.empty?

    number = numbers.shift
    compute(accumulator + number, numbers.dup) ||
      compute(accumulator * number, numbers.dup) ||
      compute("#{accumulator}#{number}".to_i, numbers.dup)
  end
end

equations = Parse.new(test: false).equations

solvable = equations.select do |result, numbers|
  Equation.new(result, numbers).solvable?
end

pp solvable.map(&:first).sum

solvable = equations.select do |result, numbers|
  Equation.new(result, numbers).solvable? || EquationWithConcat.new(result, numbers).solvable?
end

pp solvable.map(&:first).sum
