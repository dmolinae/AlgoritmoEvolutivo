require_relative "Classes"

population = Population.new.load("population.txt")
#puts population.solutions[0].fitness


pm=0.15
pcm=Integer(population.solutions.length*pm)

pcm.times do
  randomArrayPosition = rand(0..4)
  random = rand(0..population.solutions.length-1)
  randomDoorsSolution = population.solutions[random].doors
  #obtengo las paredes externas
  external_walls = Patches.new("school.plan").getExternalWalls()
  bool = false
  randomEW = rand(0..external_walls.length-1)
  selectedEW = Door.new(external_walls[randomEW][0],external_walls[randomEW][1])

  selectedDoorsSolution = []
  bool = true
  while(bool)
    for i in 0..4 
      selectedDoorsSolution.push(randomDoorsSolution[i])
    end
    bool = selectedDoorsSolution.include? selectedEW
  end
  #puts random  
  #puts "#{selectedDoorsSolution}"
  selectedDoorsSolution[randomArrayPosition] = selectedEW
  #puts "#{selectedDoorsSolution}"
  
  #agregar a populaton.solutions
  solution = Solution.new(selectedDoorsSolution)
  solution.test
  population.solutions[random] = solution
  #puts population.solutions[random].doors[0]
  
end
