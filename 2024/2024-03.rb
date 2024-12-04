require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def instructions
    @instructions ||= input.readlines.flat_map do |line|
      line.scan(/(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/).map(&:last)
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

parse = Parse.new(test: false)

multiplications = parse.instructions.filter_map do |instruction|
  instruction.scan(/\d{1,3}/).map(&:to_i).reduce(:*) if instruction.start_with?("mul")
end

pp multiplications.sum

multiply = true
multiplications = parse.instructions.filter_map do |instruction|
  if instruction.start_with?("mul")
    instruction.scan(/\d{1,3}/).map(&:to_i).reduce(:*) if multiply
  elsif instruction == "do()"
    multiply = true
    nil
  else
    multiply = false
  end
end

pp multiplications.sum
