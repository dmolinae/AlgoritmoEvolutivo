require_relative "Classes"

population = Population.new.fromFile("school.plan",20)
population.generateFile
