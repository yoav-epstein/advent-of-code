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
  if node.downcase == node
    if visited[node] == 2
      return 0
    elsif visited[node] == 1
      return 0 if visited.values.any? { |v| v == 2 }
      visited[node] = 2
    else
      visited[node] = 1
    end
  end

  routes[node].flat_map do |new_node|
    traverse(routes, new_node, visited.dup)
  end.sum
end

count = traverse(routes, 'start', {})
p count
