input = File.read('2020/2020-04.data')

passports = input.split("\n\n")

passports = passports.map do |p|
  p.gsub("\n", ' ').split(' ').map { |t| t.split(':') }.to_h
end

passports.each do |passport|
  passport.delete('cid')
end

valid = passports.select do |passport|
  next unless passport.size == 7

  next unless (1920..2002).cover? passport['byr'].to_i
  next unless (2010..2020).cover? passport['iyr'].to_i
  next unless (2020..2030).cover? passport['eyr'].to_i

  height = passport['hgt'][0..-2].to_i
  unit = passport['hgt'][-2..-1]
  if unit == 'cm'
    next unless (150..193).cover? height
  elsif unit == 'in'
    next unless (59..76).cover? height
  else
    next
  end

  hcl = passport['hcl']
  next unless hcl[0] == '#' && hcl.length == 7
  next unless hcl[1..-1].each_char.all? { |c| (c >= '0' && c <= '9') || (c >= 'a' && 'c' <= 'f') }

  next unless %w[amb blu brn gry grn hzl oth].include? passport['ecl']

  pid = passport['pid']
  next unless pid.length == 9
  next unless pid.each_char.all? { |c| (c >= '0' && c <= '9') }

  true
end

pp valid.size
