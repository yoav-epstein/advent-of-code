inputs = File.readlines('2021/2021-12.data', chomp: true)

routes = Hash.new { [] }

inputs.each do |input|
  left, right = input.split('-')
  routes[left] = routes[left] << right unless left == 'end' || right == 'start'
  routes[right] = routes[right] << left unless right == 'end' || left == 'start'
end

p routes

def traverse(routes, node, visited)
  return 1 if node == 'end'
  return 0 if visited[node] && node.downcase == node

  visited[node] = true
  routes[node].flat_map do |new_node|
    traverse(routes, new_node, visited.dup)
  end.sum
end

count = traverse(routes, 'start', {})
p count
