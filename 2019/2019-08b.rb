image = File.read('2019/2019-08.data')

width = 25
height = 6

data = image.strip.chars.map(&:to_i)
layers = data.each_slice(width * height).to_a

def print_layer(layer)
  layer.each_slice(25) do |row|
    row.each do |p|
      print case p
            when 0
              '  '
            when 1
              '# '
            else
              '. '
            end
    end
    puts
  end
  puts "\n\n"
end

final_layer = layers.first
layers.each do |layer|
  final_layer = final_layer.zip(layer).map do |a, b|
    a == 2 ? b : a
  end
end

print_layer(final_layer)
