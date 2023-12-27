require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
    @games = []
  end

  def data
    input.readlines.map do |line|
      game = Game.new
      game_str, draws_str = line.split ":"
      game.number = game_str.split(" ").last.to_i
      game.draws = draws_str.split(";").map do |draw_str|
        draw = Draw.new
        draw_str.tr(",","").split(" ").each_slice(2) do |count, color|
          draw.send("#{color}=", count.to_i)
        end
        draw
      end
      game
    end
  end

  private

  def input
    Input.new(2023, 2, test: @test)
  end
end

Game = Struct.new(:number, :draws) do
  def possible?
    draws.all?(&:possible?)
  end

  def power
    max_red * max_green * max_blue
  end

  private

  def max_red
    draws.map(&:red).compact.max || 0
  end

  def max_green
    draws.map(&:green).compact.max || 0
  end

  def max_blue
    draws.map(&:blue).compact.max || 0
  end
end

Draw = Struct.new(:red, :green, :blue) do
  def possible?
    red_possible? && green_possible? && blue_possible?
  end

  private

  def red_possible?
    red.nil? || red <= 12
  end

  def green_possible?
    green.nil? || green <= 13
  end

  def blue_possible?
    blue.nil? || blue <= 14
  end
end

pp Parse.new.data.select(&:possible?).map(&:number).sum

pp Parse.new.data.map(&:power).sum
