require_relative "Classes"

population = Population.new.load("population.txt")

#SELECTION
selected_solutions = []
population.solutions.length.times do
	k = 3
	select = []
  k.times do
		select.push(population.solutions[rand(0..population.solutions.length-1)])
		#puts select[i].fitness
	end

	best = select[0]

	for j in 1..(k-1)
		if best.fitness > select[j].fitness
			best = select[j]
		end
	end
	selected_solutions.push(best)
end
selected_population = Population.new(selected_solutions)

#CROSSOVER
pc = 0.2
number_parents = Integer(pc * selected_population.solutions.length)

parents = []

number_parents.times do
  random = rand(0..population.solutions.length-1)
  parents.push([selected_population.solutions[random],random])
end

crossover_population = selected_population
(0..number_parents-1).step(2) do |i|
  pcc = rand(1..4)

  children_doors = parents[i][0].doors[0..pcc-1] + parents[i+1][0].doors[pcc..4]
  new_solution = Solution.new(children_doors)
  #new_solution.test
  crossover_population.solutions[parents[i][1]] = new_solution

  children_doors = parents[i+1][0].doors[0..pcc-1] + parents[i][0].doors[pcc..4]
  new_solution = Solution.new(children_doors)
  #new_solution.test
  crossover_population.solutions[parents[i][1]] = new_solution
end
