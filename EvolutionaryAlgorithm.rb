require_relative "Classes"

population = Population.new.load("population.txt")
puts population.solutions[0].fitness
