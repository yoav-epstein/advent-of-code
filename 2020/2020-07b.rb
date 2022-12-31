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

answers = rules.map { |bag, others| [bag, 0] if others.empty? }.compact.to_h

query = 'shiny gold'

pp answers

def count(bag, rules, answers)
  return answers[bag] if answers.has_key?(bag)

  total = rules[bag].map do |count, other_bag|
    count + count * count(other_bag, rules, answers)
  end
  answers[bag] = total.sum
end

count(query, rules, answers)

pp answers

pp answers[query]
