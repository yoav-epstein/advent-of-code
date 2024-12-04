require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def machines
    input.readlines.map(&:chomp).slice_after(&:empty?).map do |lines|
      lines.first(3).map { |line| line.scan(/\d+/).map(&:to_i) }
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

class Claw
  def initialize(machine)
    @machine = machine
  end

  def tokens
    won_prize? ? a * 3 + b : 0
  end

  private

  attr_reader :machine

  def won_prize?
    a * ax + b * bx == px && a * ay + b * by == py
  end

  def a
    # a * ax + b * bx = px
    # a * ay + b * by = py
    #
    # a * ax * by + b * bx * by = px * by
    # a * ay * bx + b * bx * by = py * bx
    #
    # a (ax * by - ay * bx) = px * by - py * bx

    @a ||= (px * by - py * bx) / (ax * by - ay * bx)
  end

  def b
    # a * ax + b * bx = px
    # a * ay + b * by = py
    #
    # a * ax * ay + b * bx * ay = px * ay
    # a * ax * ay + b * by * ax = py * ax
    #
    # b (bx * ay - by * ax) = px * ay - py * ax

    @b ||= (px * ay - py * ax) / (bx * ay - by * ax)
  end

  def ax
    @ax = button_a[0]
  end

  def ay
    @ay = button_a[1]
  end

  def bx
    @bx = button_b[0]
  end

  def by
    @by = button_b[1]
  end

  def px
    @px = prize[0]
  end

  def py
    @py = prize[1]
  end

  def button_a
    machine[0]
  end

  def button_b
    machine[1]
  end

  def prize
    machine[2].map { |n| n + offset }
  end

  def offset
    0
  end
end

class Claw2 < Claw
  def offset
    10_000_000_000_000
  end
end

parse = Parse.new(test: false)

tokens = parse.machines.sum do |machine|
  Claw.new(machine).tokens
end

pp tokens

tokens = parse.machines.sum do |machine|
  Claw2.new(machine).tokens
end

pp tokens
