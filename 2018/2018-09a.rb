def play(players, marbles)
  scores = Hash.new(0)
  circle = [0, 2, 1]
  size = 3
  index = 1
  3.upto(marbles) do |marble|
    if (marble % 23).zero?
      index = (index - 7) % size
      score = circle.delete_at(index) + marble
      size -= 1
      scores[marble % players] += score
      puts marbles - marble if (marble % 2_300).zero?
    else
      index += 2
      index = 1 if index > size
      size += 1
      circle.insert(index, marble)
    end
  end
  puts scores.inspect
  puts scores.max_by { |_player, score| score }.inspect
end

play(419, 7105200) # [77, 3444129546]

