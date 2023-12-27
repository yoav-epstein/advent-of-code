class Input
  def initialize(year, day, test: false)
    @year = year
    @day = (day / 10).to_s + (day % 10).to_s
    @test = test
  end

  def readlines
    File.readlines filename
  end

  private

  attr_reader :year, :day, :test

  def filename
    "#{year}/data/#{year}-#{day}.#{extension}"
  end

  def extension
    test ? "test" : "data"
  end
end
