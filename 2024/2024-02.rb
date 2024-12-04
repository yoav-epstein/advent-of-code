require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def reports
    return @reports if defined?(@reports)

    @reports = input.readlines.map do |line|
      line.split.map(&:to_i)
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

class Report
  def initialize(report)
    @report = report
  end

  def safe?
    min, max = deltas.minmax
    (min >= 1 && max <= 3) || (min >= -3 && max <= -1)
    # (1..3).cover?(min..max) || (-3..-1).cover?(min..max)
  end

  private

  def deltas
    @report.each_cons(2).map do |a, b|
      (b - a)
    end
  end
end

class DampenerReport < Report
  def safe?
    return true if super

    sub_reports.any? do |sub_report|
      Report.new(sub_report).safe?
    end
  end

  private

  def sub_reports
    @report.combination(@report.size - 1).to_a
  end
end

parse = Parse.new(test: false)

safe = parse.reports.map do |report|
  Report.new(report).safe? ? 1 : 0
end

pp safe.sum

safe = parse.reports.map do |report|
  DampenerReport.new(report).safe? ? 1 : 0
end

pp safe.sum
