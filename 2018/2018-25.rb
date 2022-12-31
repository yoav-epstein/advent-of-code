str = "1,-1,0,1
2,0,-1,0
3,2,-1,0
0,0,3,1
0,0,-1,-1
2,3,-2,0
-2,2,0,0
2,-2,0,-1
1,-1,0,-1
3,2,0,2"

points = str.split("\n").map { |row| row.split(',').map(&:to_i) }
puts points.inspect
graph = {}
points.each { |point| graph[point] = [] }
points.permutation(2) do |a, b|
  distance = 0
  0.upto(a.size - 1) do |i|
    distance += (a[i] - b[i]).abs
  end
  graph[a] += [b] if distance <= 3
end
puts graph.inspect


# hit = true
# while hit
#   puts 'start'
#   puts graph.inspect
#   hit = false
#   graph.each do |k, v|
#     v.each do |key|
#       next if graph[key].nil? || graph[key].empty?
#
#       puts key.inspect
#
#       puts 'hit'
#       hit = true
#       graph[k] += graph[key].reject { |vals| vals == k }
#       graph.delete(key)
#     end
#   end
# end

puts graph.inspect
puts graph.keys.size

