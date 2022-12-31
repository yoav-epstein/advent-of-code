str="initial state: ###..###....####.###...#..#...##...#..#....#.##.##.#..#.#..##.#####..######....#....##..#...#...#.#

..#.# => #
###.# => .
#.#.# => .
.#.#. => .
##... => #
...## => .
.##.# => .
.#... => #
####. => #
....# => .
.##.. => #
.#### => #
..### => .
.###. => #
##### => #
..#.. => #
#..#. => .
###.. => #
#..## => #
##.## => #
##..# => .
.#..# => #
#.#.. => #
#.### => #
#.##. => #
..... => .
.#.## => #
#...# => .
...#. => #
..##. => #
##.#. => #
#.... => ."

array = str.split("\n")
state = '.' * 20 + array.shift[15..-1] + '.' * 30

array.shift
commands = array.map do |line|
  [line[0..4], line[-1]]
end.to_h

def next_state(state, commands)
  new_state = 2.upto(state.size - 3).map do |i|
    command = state[i - 2..i + 2]
    commands[command] || '.'
  end
  '..' + new_state.join('') + '..'
end

puts state
20.times do
  state = next_state(state, commands)
  puts state
end

pots = state.split('').map.with_index do |val, index|
  val == '#' ? index - 20 : 0
end

pp pots.sum
