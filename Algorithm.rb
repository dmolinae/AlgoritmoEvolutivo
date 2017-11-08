require_relative "EvolutionClass"

iterations = 40
pc = 0.2
pm = 0.15
k_array = [3, 8, 12]

for k in k_array do
  population = Marshal.load(File.read("population.txt"))
  evolution = Evolution.new(population, k, pc, pm, iterations)
  evolution.start
  evolution.generateCSV
end
