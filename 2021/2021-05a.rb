input = File.readlines('2021/2021-05.data', chomp: true)

lines = input.map do |data|
  left, right = data.split(' -> ')
  [left.split(',').map(&:to_i), right.split(',').map(&:to_i)]
end

p lines

grid = []
lines.each do |line|
  x1, y1 = *line[0]
  x2, y2 = *line[1]
  if x1 == x2
    # vertical
    miny, maxy = *[y1, y2].minmax
    miny.upto(maxy) do |y|
      grid[y] ||= []
      grid[y][x1] = (grid[y][x1] || 0) + 1
    end
  elsif y1 == y2
    # horizontal
    minx, maxx = *[x1, x2].minmax
    grid[y1] ||= []
    minx.upto(maxx) { |col| grid[y1][col] = (grid[y1][col] || 0) + 1 }
  end
end

p grid

count = grid.reduce(0) do |count, row|
  p count
  next count if row.nil?

  count + row.compact.select { |v| v > 1 }.count
end

p count
