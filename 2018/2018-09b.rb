require_relative '../linked'

def play(players, marbles)
  scores = Hash.new(0)
  circle = Linked::CircularList.new
  circle.append(0)
  1.upto(marbles) do |marble|
    if (marble % 23).zero?
      7.times { circle.previous }
      score = circle.delete + marble
      scores[marble % players] += score
      puts marbles - marble if (marble % 230_000).zero?
    else
      circle.next
      circle.append(marble)
    end
  end
  puts scores.inspect
  puts scores.max_by { |_player, score| score }.inspect
end

# play(419, 7105200) # [77, 3444129546]

play(419, 7105200)
