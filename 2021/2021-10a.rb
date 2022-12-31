inputs = File.readlines('2021/2021-10.data', chomp: true)

invalids = inputs.map do |line|
  stack = []
  line.each_char.detect do |char|
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
end

p invalids

points = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

sum = invalids.compact.map do |char|
  points[char]
end.sum

p sum
