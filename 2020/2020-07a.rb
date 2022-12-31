input = File.read('2020/2020-07.data')

rules = input.split("\n")

rules = rules.map do |rule|
  bag, others = rule.gsub(' bags', '').gsub(' bag', '').split(' contain ')
  others = others[0..-2].split(', ').map do |other|
    next if other == 'no other'

    count, color1, color2 = other.split(' ')
    [count.to_i, "#{color1} #{color2}"]
  end.compact
  [bag, others]
end.to_h

pp rules

query = 'shiny gold'
answers = { query => true }

def can_hold?(bag, query, answers, rules)
  return answers[bag] if answers.has_key?(bag)

  rules[bag].any? do |_count, other_bag|
    can_hold?(other_bag, query, answers, rules)
  end
end

rules.keys.each do |bag|
  answers[bag] = can_hold?(bag, query, answers, rules)
end

pp answers.values.map { |v| v ? 1 : 0 }.sum - 1
