require_relative "../input"

class Parse
  def initialize(test: false)
    @test = test
  end

  def disk_map
    input.readlines.first.chomp.chars.map(&:to_i)
  end

  private

  def input
    Input.new(filename[0..3].to_i, filename[5..6].to_i, test: @test)
  end

  def filename
    @filename ||= __FILE__.split("/").last
  end
end

class Disk
  def initialize(disk_map)
    @disk_map = disk_map
  end

  def checksum
    compact_map.each_with_index.sum do |file, index|
      file * index
    end
  end

  private

  attr_reader :disk_map

  def compact_map
    @compact_map = []
    while files.any?
      file, count = files.shift
      count.times { @compact_map << file }
      break if files.empty?

      free_space = free_spaces.shift
      while free_space.positive?
        file, count = files.pop

        if free_space >= count
          count.times { @compact_map << file }
          free_space -= count
        else
          free_space.times { @compact_map << file }
          files.push [file, count - free_space]
          free_space = 0
        end
      end
    end
    @compact_map
  end

  def files
    @files ||= disk_map.filter_map.with_index { |count, index| [index / 2, count] if index.even? }
  end

  def free_spaces
    @free_spaces ||= disk_map.filter_map.with_index { |file, index| file if index.odd? }
  end
end

class Disk2 < Disk
  private

  MAX_INDEX = 30_000

  def compact_map
    @compact_map = []
    defragment.each do |frag|
      frag[:files].each do |file, count|
        count.times { @compact_map << file }
      end
      frag[:free_space].times { @compact_map << 0 }
    end
    @compact_map
  end

  def defragment
    combined = disk_map.map.with_index do |count, index|
      if index.even?
        { free_space: 0, files: [[index / 2, count]] }
      else
        { free_space: count, files: [] }
      end
    end

    free_spaces_by_count = Hash.new { [] }
    free_spaces.each_with_index do |count, index|
      free_spaces_by_count[count] <<= index * 2 + 1
    end

    (files.size - 1).downto(0) do |files_index|
      file, file_count = files[files_index]

      combined_index, free_space_count = file_count.upto(9).map do |count|
        [free_spaces_by_count[count].first || MAX_INDEX, count]
      end.min

      next if combined_index == MAX_INDEX || combined_index > files_index * 2

      combined[combined_index][:free_space] -= file_count
      combined[combined_index][:files] <<= [file, file_count]
      combined[files_index * 2] = { free_space: file_count, files: [] }

      free_spaces_by_count[free_space_count].shift

      extra_space = free_space_count - file_count
      if extra_space.positive?
        free_spaces_by_count[extra_space] <<= combined_index
        free_spaces_by_count[extra_space].sort!
      end
    end

    combined
  end
end

parse = Parse.new(test: false)
disk = Disk.new(parse.disk_map)

pp disk.checksum

disk = Disk2.new(parse.disk_map)

pp disk.checksum
