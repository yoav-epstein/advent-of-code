data = File.read("2022/data/2022-06.data")

def uniq_sequence_of(count, data)
  data.chars.each_cons(count).with_index do |sequence, index|
    return index + count if sequence.uniq.size == count
  end
end

pp uniq_sequence_of 4, data
pp uniq_sequence_of 14, data
