input = File.read('2020/2020-03.data')

map = input.split("\n")

def slope(offset_row, offset_column, map)
  height = map.size
  width = map[0].size

  trees = 0
  column = 0
  row = 0
  while row < height do
    trees += 1 if map[row][column] == '#'
    column = (column + offset_column) % width
    row += offset_row
  end

  trees
end

trees = [
  slope(1, 1, map),
  slope(1, 3, map),
  slope(1, 5, map),
  slope(1, 7, map),
  slope(2, 1, map)
]

pp trees

pp trees.reduce(&:*)
