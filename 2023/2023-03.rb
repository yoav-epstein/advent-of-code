require_relative "../input"
require "set"

class Parse
  def initialize(test: false)
    @test = test
  end

  def data
    input.readlines.map(&:chomp)
  end

  private

  def input
    Input.new(2023, 3, test: @test)
  end
end

class Engine
  def initialize(test: false)
    @test = test
    @numbers = {}
    @parts = []
  end

  def parts
    build
    @numbers.values.select(&:included)
  end

  def gear_ratios
    build
    @parts.map(&:gear_ratio).compact
  end

  private

  def build
    parse_grid
    numbers_by_parts
  end

  def parse_grid
    Parse.new(test: @test).data.each.with_index do |values, row|
      number = nil

      values.each_char.with_index do |value, column|
        if value == "."
          number = nil
        elsif value >= "0" && value <= "9"
          if number
            number.add_digit value.to_i
          else
            number = Number.new(row, column, 1, value.to_i, false)
            @numbers["#{row}-#{column}"] = number
          end
        else
          number = nil
          @parts << Part.new(row, column, value, Set.new)
        end
      end
    end
  end

  def numbers_by_parts
    @parts.each do |part|
      (part.row - 1..part.row + 1).each do |row|
        (part.column - 1..part.column + 1).each do |column|
          number = number_at(row, column)
          next unless number

          number.included = true
          part.numbers << number
        end
      end
    end
  end

  def number_at(row, column)
    (column - 3..column).each do |col|
      number = @numbers["#{row}-#{col}"]
      next unless number

      return number if number.column + number.length - 1 >= column
    end
    nil
  end
end

Number = Struct.new(:row, :column, :length, :value, :included) do
  def add_digit(digit)
    self.value = value * 10 + digit
    self.length += 1
  end
end

Part = Struct.new(:row, :column, :symbol, :numbers) do
  def gear_ratio
    return unless symbol == "*" && numbers.size == 2

    numbers.map(&:value).reduce(:*)
  end
end

pp Engine.new.parts.map(&:value).sum

pp Engine.new.gear_ratios.sum
