require_relative "Classes"

population = Population.new.fromFile("office.plan",20)
population.generateFile
