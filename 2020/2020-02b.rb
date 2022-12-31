input = File.read('2020/2020-02.data')

passwords = input.split("\n")
passwords = passwords.map do |password|
  rule, passwd = *password.split(':')
  times, letter = *rule.split(' ')
  pos1, pos2 = times.split('-')
  [pos1.to_i, pos2.to_i, letter, passwd.strip]
end

valid = passwords.select do |password|
  pos1, pos2, letter, passwd = *password

  (passwd[pos1 - 1] == letter) ^ (passwd[pos2 - 1] == letter)
end

pp valid.size
