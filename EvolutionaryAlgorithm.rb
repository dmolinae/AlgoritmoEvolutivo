require_relative "Classes"

population = Population.new.load("population.txt")

#SELECTION
selected_population = []
x = 20
for n in 0..(x-1) 
	k = 3
	select = []
	for i in 0..(k-1)
		select.push(population.solutions[rand(0..population.solutions.length-1)])
		#puts select[i].fitness
	end

	best = select[0]

	for j in 1..(k-1)
		if best.fitness > select[j].fitness
			best = select[j]
		end
	end
	selected_population.push(best)
	puts selected_population[n].fitness
	#puts "#{selected_population}"
end

