require_relative "RepresentationClasses"

population = Population.new.fromFile("conference.plan",20)
population.generateFile
