require_relative "EvolutionClass"
require_relative "RepresentationClasses"

population = Population.new.fromFile("conference.plan",20)
iterations = 40
pc = 0.2
pm = 0.15
k_array = [3, 8, 12]

for k in k_array do
  evolution = Evolution.new(population, k, pc, pm, iterations)
  evolution.start
  evolution.generateCSV
end
