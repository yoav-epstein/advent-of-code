input = File.read('2020/2020-25.data')

keys = input.split("\n")

keys = keys.map(&:to_i)

key1, key2 = *keys

pp keys

count = 0
subject_number = 7
mod = 20201227
key = 1

while key != key1 && key != key2
  key = (key * subject_number) % mod
  count += 1
end

pp key
pp count

if key == key1
  subject_number = key2
else
  subject_number = key1
end

key = 1
count.times do
  key = (key * subject_number) % mod
end

pp key
