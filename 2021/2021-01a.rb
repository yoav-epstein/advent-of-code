input = File.readlines('2021/2021-01.data')

depths = input.map(&:to_i)

deltas = depths.each_cons(2).map { |previous, depth| depth - previous }

p deltas.select(&:positive?).size
