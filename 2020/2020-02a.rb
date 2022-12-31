input = File.read('2020/2020-02.data')

passwords = input.split("\n")
passwords = passwords.map do |password|
  rule, passwd = *password.split(':')
  times, letter = *rule.split(' ')
  min, max = times.split('-')
  [min.to_i, max.to_i, letter, passwd.strip]
end

valid = passwords.select do |password|
  min, max, letter, passwd = *password
  count = passwd.split('').select { |char| char == letter }.size
  count >= min && count <= max
end

pp valid.size
