lines = File.readlines("2022/data/2022-02.data")

def score_for_win(p1, p2)
  return 3 if p1 == p2

  case p1
  when :rock
    p2 == :paper ? 6 : 0
  when :paper
    p2 == :scissors ? 6 : 0
  when :scissors
    p2 == :rock ? 6 : 0
  end
end

def score_for_play(p2)
  {
    rock: 1,
    paper: 2,
    scissors: 3
  }[p2]
end

def play_for(p1, p2)
  return p1 if p2 == "Y"

  case p1
  when :rock
    p2 == "X" ? :scissors : :paper
  when :paper
    p2 == "X" ? :rock : :scissors
  when :scissors
    p2 == "X" ? :paper : :rock
  end
end

strategy_to_play = {
  "A" => :rock,
  "B" => :paper,
  "C" => :scissors,
  "X" => :rock,
  "Y" => :paper,
  "Z" => :scissors
}

moves = lines.map do |line|
  line.strip.split(" ").map { |move| strategy_to_play[move] }
end

scores = moves.map do |move|
  score_for_win(*move) + score_for_play(move.last)
end

pp scores.sum

moves = lines.map do |line|
  p1, p2 = *line.strip.split(" ")
  [strategy_to_play[p1], play_for(strategy_to_play[p1], p2)]
end

scores = moves.map do |move|
  score_for_win(*move) + score_for_play(move.last)
end

pp scores.sum
