input = File.read('2020/2020-04.data')

passports = input.split("\n\n")

passports = passports.map do |p|
  p.gsub("\n", ' ').split(' ').map { |t| t.split(':') }.to_h
end

passports.each do |passport|
  passport.delete('cid')
end

valid = passports.select { |passport| passport.size == 7 }

pp valid.size
