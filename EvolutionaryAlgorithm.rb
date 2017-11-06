require_relative "Classes"

population = Population.new.load("population.txt")
puts population.solutions[0].fitness

pc = 0.25
number_parents = Integer(pc * population.solutions.length)
parents = []
number_parents.times do
  parents.push(population.solutions[rand(0..population.solutions.length-1)])
end

