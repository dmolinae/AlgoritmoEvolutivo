require_relative "Classes"

population = Marshal.load(File.read("population.txt"))
iterations = 40
pc = 0.2
pm = 0.15
k_array = [3,5,8]

for k in k_array do

  populations = []
  population.setBestSolution
  population.setFitnessAverage
  populations.push(population)

  iterations.times do |z|
    #SELECTION
    selected_solutions = []
    population.solutions.length.times do
      select = []
      k.times do
        select.push(population.solutions[rand(0..population.solutions.length-1)])
      end

      best = select[0]

      for j in 1..(k-1)
        if best.fitness > select[j].fitness
          best = select[j]
        end
      end
      selected_solutions.push(best)
    end
    selected_population = Population.new(
      selected_solutions,
      population.plan)

    #CROSSOVER
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
      crossover_population.solutions[parents[i][1]] = new_solution

      children_doors = parents[i+1][0].doors[0..pcc-1] + parents[i][0].doors[pcc..4]
      new_solution = Solution.new(children_doors)
      
      crossover_population.solutions[parents[i+1][1]] = new_solution
    end

    #MUTATION
    pcm=Integer(crossover_population.solutions.length*pm)

    mutated_population = crossover_population

    pcm.times do
      randomArrayPosition = rand(0..4)
      random = rand(0..crossover_population.solutions.length-1)
      randomDoorsSolution = crossover_population.solutions[random].doors
      #obtengo las paredes externas
      external_walls = Patches.new(mutated_population.plan).getExternalWalls()
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
      selectedDoorsSolution[randomArrayPosition] = selectedEW
      
      #agregar a crossover_population.solution
      solution = Solution.new(selectedDoorsSolution)

      mutated_population.solutions[random] = solution
    end

    evaluated_population = mutated_population
    evaluated_population.solutions.each do |solution|
      solution.test
    end

    #REINSERTION
    if z < 35
      population = evaluated_population
    else
      combination = evaluated_population.solutions + population.solutions
      sort_array = []
      combination.each do |solution|
        sort_array.push([solution,solution.fitness])		
      end
      sorted = sort_array.sort {|a,b| a[1] <=> b[1]}

      population = Population.new(
        sorted.take(20).map { |e| e[0] },
        population.plan)
    end

    puts "generacion " + (z+1).to_s
    population.solutions.each do |solution|
      puts solution.fitness
    end

    population.setBestSolution
    population.setFitnessAverage
    populations.push(population)
  end

  Population.generateCSV(
    iterations.to_s + "-Generations_K:" + k.to_s + "_Plan:" + population.plan + ".csv",populations) 

end
