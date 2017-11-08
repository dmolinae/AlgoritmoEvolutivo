def crossover(solutions, pc)
  number_parents = Integer(pc * solutions.length)

  parents = []
  randoms = []
  number_parents.times do
    begin
      random = rand(0..solutions.length-1)
    end while randoms.include?random
    randoms.push(random)
    parents.push([solutions[random],random])
  end

  (0..number_parents-1).step(2) do |i|
    pcc = rand(1..4)

    children_doors = parents[i][0][0..pcc-1] + parents[i+1][0][pcc..4]
    new_solution = children_doors
    solutions[parents[i][1]] = new_solution

    children_doors = parents[i+1][0][0..pcc-1] + parents[i][0][pcc..4]
    new_solution = children_doors
    solutions[parents[i+1][1]] = new_solution
  end
  return solutions
end

solutions = [
  [[1,1],[1,1],[1,1],[1,1],[1,1]],
  [[2,2],[2,2],[2,2],[2,2],[2,2]],
  [[3,3],[3,3],[3,3],[3,3],[3,3]],
  [[4,4],[4,4],[4,4],[4,4],[4,4]]
]
puts "#{crossover(solutions,0.5)}"
