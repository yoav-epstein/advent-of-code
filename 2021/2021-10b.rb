inputs = File.readlines('2021/2021-10.data', chomp: true)

incomplete = inputs.map do |line|
  stack = []
  invalid = line.each_char.detect do |char|
    case char
    when ']'
      c = stack.pop
      if c != '['
        break char
      end
    when '}'
      c = stack.pop
      if c != '{'
        break char
      end
    when ')'
      c = stack.pop
      if c != '('
        break char
      end
    when '>'
      c = stack.pop
      if c != '<'
        break char
      end
    else
      stack.push char
    end
    nil
  end
  stack unless invalid
end

points = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}

p incomplete

sums = incomplete.compact.map do |stack|
  stack.reverse.reduce(0) do |sum, char|
    sum * 5 + points[char]
  end
end

p sums

p sums.sort[sums.size / 2]
