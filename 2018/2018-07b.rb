str = "Step P must be finished before step R can begin.
Step V must be finished before step J can begin.
Step O must be finished before step K can begin.
Step S must be finished before step W can begin.
Step H must be finished before step E can begin.
Step K must be finished before step Y can begin.
Step B must be finished before step Z can begin.
Step N must be finished before step G can begin.
Step W must be finished before step I can begin.
Step L must be finished before step Y can begin.
Step U must be finished before step Q can begin.
Step R must be finished before step Z can begin.
Step Z must be finished before step E can begin.
Step C must be finished before step I can begin.
Step I must be finished before step Q can begin.
Step D must be finished before step E can begin.
Step A must be finished before step J can begin.
Step G must be finished before step Y can begin.
Step M must be finished before step T can begin.
Step E must be finished before step X can begin.
Step F must be finished before step T can begin.
Step X must be finished before step J can begin.
Step Y must be finished before step J can begin.
Step T must be finished before step Q can begin.
Step J must be finished before step Q can begin.
Step E must be finished before step Y can begin.
Step A must be finished before step T can begin.
Step P must be finished before step H can begin.
Step W must be finished before step R can begin.
Step Y must be finished before step Q can begin.
Step W must be finished before step M can begin.
Step O must be finished before step M can begin.
Step H must be finished before step R can begin.
Step N must be finished before step L can begin.
Step V must be finished before step W can begin.
Step S must be finished before step Q can begin.
Step D must be finished before step J can begin.
Step W must be finished before step E can begin.
Step V must be finished before step Y can begin.
Step O must be finished before step C can begin.
Step B must be finished before step T can begin.
Step W must be finished before step T can begin.
Step G must be finished before step T can begin.
Step D must be finished before step T can begin.
Step P must be finished before step E can begin.
Step P must be finished before step J can begin.
Step G must be finished before step E can begin.
Step Z must be finished before step M can begin.
Step K must be finished before step T can begin.
Step H must be finished before step U can begin.
Step P must be finished before step T can begin.
Step W must be finished before step A can begin.
Step A must be finished before step F can begin.
Step F must be finished before step Y can begin.
Step H must be finished before step M can begin.
Step T must be finished before step J can begin.
Step O must be finished before step S can begin.
Step P must be finished before step M can begin.
Step X must be finished before step T can begin.
Step S must be finished before step J can begin.
Step H must be finished before step C can begin.
Step B must be finished before step W can begin.
Step K must be finished before step N can begin.
Step E must be finished before step T can begin.
Step S must be finished before step Y can begin.
Step C must be finished before step G can begin.
Step R must be finished before step D can begin.
Step N must be finished before step U can begin.
Step O must be finished before step L can begin.
Step B must be finished before step F can begin.
Step S must be finished before step F can begin.
Step X must be finished before step Y can begin.
Step S must be finished before step D can begin.
Step R must be finished before step E can begin.
Step S must be finished before step A can begin.
Step S must be finished before step X can begin.
Step A must be finished before step G can begin.
Step E must be finished before step F can begin.
Step P must be finished before step A can begin.
Step A must be finished before step M can begin.
Step E must be finished before step Q can begin.
Step H must be finished before step W can begin.
Step W must be finished before step U can begin.
Step F must be finished before step Q can begin.
Step I must be finished before step J can begin.
Step H must be finished before step G can begin.
Step I must be finished before step G can begin.
Step P must be finished before step X can begin.
Step I must be finished before step D can begin.
Step R must be finished before step X can begin.
Step S must be finished before step I can begin.
Step Y must be finished before step T can begin.
Step R must be finished before step G can begin.
Step I must be finished before step X can begin.
Step B must be finished before step D can begin.
Step X must be finished before step Q can begin.
Step F must be finished before step X can begin.
Step V must be finished before step R can begin.
Step C must be finished before step J can begin.
Step L must be finished before step Q can begin.
Step K must be finished before step B can begin."

hash = Hash.new([])
str.split("\n").each do |step|
  hash[step[36]] += [step[5]]
end

workers = Array.new(5, [])

def available(completed, in_progress, hash)
  'A'.upto('Z').reject do |letter|
    completed.include?(letter) || in_progress.include?(letter) || (hash[letter] - completed).any?
  end
end

time = 0
completed = []
loop do
  workers.each do |worker|
    completed += [worker.first] if worker.last == time
  end

  in_progress = workers.map(&:first).compact

  ready = available(completed, in_progress, hash)
  workers = workers.map do |worker|
    if worker.empty? || worker.last == time
      letter = ready.shift
      if letter
        [letter, time + letter.ord - 'A'.ord + 61]
      else
        []
      end
    else
      worker
    end
  end
  # pp workers
  times = workers.compact.map { |_letter, t| t }.compact
  # pp times
  break if times.empty?

  time = times.min
end

pp completed.join('')
pp time
