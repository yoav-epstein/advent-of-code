input = File.readlines('2021/2021-05.data', chomp: true)

lines = input.map do |data|
  left, right = data.split(' -> ')
  [left.split(',').map(&:to_i), right.split(',').map(&:to_i)]
end

count = 0
grid = []
lines.each do |line|
  x1, y1 = *line[0]
  x2, y2 = *line[1]
  if x1 == x2
    #vertical
    miny, maxy = *[y1, y2].minmax
    miny.upto(maxy) do |y|
      grid[y] ||= []
      grid[y][x1] = (grid[y][x1] || 0) + 1
      count += 1 if grid[y][x1] == 2
    end
  elsif y1 == y2
    #horizontal
    minx, maxx = *[x1, x2].minmax
    grid[y1] ||= []
    minx.upto(maxx) do |col|
      grid[y1][col] = (grid[y1][col] || 0) + 1
      count += 1 if grid[y1][col] == 2
    end
  else
    #diagonal
    if x1 < x2
      offset = y1 < y2 ? 1 : -1
      x1.upto(x2) do |col|
        grid[y1] ||= []
        grid[y1][col] = (grid[y1][col] || 0) + 1
        count +=1 if grid[y1][col] == 2
        y1 += offset
      end
    else
      x2.upto(x1) do |col|
        offset = y2 < y1 ? 1 : -1
        grid[y2] ||= []
        grid[y2][col] = (grid[y2][col] || 0) + 1
        count +=1 if grid[y2][col] == 2
        y2 += offset
      end
    end
  end
end

p count
