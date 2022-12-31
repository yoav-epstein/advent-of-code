lines = File.readlines("2022/data/2022-07.data", chomp: true)

class Directory
  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @directories = []
    @files = []
    @bytes = 0
  end

  def size
    bytes + directories.map(&:size).sum
  end

  def add_dir(name)
    find_dir(name) || create_dir(name)
  end

  def add_file(name, bytes)
    return if files.include? name

    files << name
    self.bytes += bytes
  end

  def print(level = 0)
    puts " " * level * 2 + to_s
    directories.each { |dir| dir.print(level + 1) }
  end

  def all
    return self if directories.empty?

    directories.flat_map(&:all) + [self]
  end

  def to_s
    "#{name}. bytes = #{bytes}, size = #{size}"
  end

  attr_reader :name, :parent

  private

  attr_reader :directories, :files
  attr_accessor :bytes

  def find_dir(name)
    directories.find { |dir| dir.name == name }
  end

  def create_dir(name)
    directories.push(Directory.new(name, self)).last
  end
end

root = Directory.new("/")
cwd = root

lines.each do |line|
  if line.start_with? "$ cd"
    dir = line[5..]
    cwd = if dir[0] == "/"
            root
          elsif dir == ".."
            cwd.parent
          else
            cwd.add_dir dir
          end
  elsif line.start_with? "dir"
    cwd.add_dir line[4..]
  else
    bytes, name = *line.split(" ")
    cwd.add_file(name, bytes.to_i)
  end
end

dirs = root.all.select { |dir| dir.size <= 100_000 }
pp dirs.map(&:size).sum

unused = 70_000_000 - root.size
needed = 30_000_000 - unused

dirs = root.all.select { |dir| dir.size >= needed }
pp dirs.map(&:size).min
