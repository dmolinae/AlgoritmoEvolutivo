require_relative "RepresentationClasses"

class Evolution
  def initialize(init_population, k, pc, pm, iterations)
    @init_population = Population.new(
      init_population.solutions,
      init_population.plan
    )
    @k = k
    @pc = pc
    @pm = pm
    @iterations = iterations

    @init_population.setFitnessAverage
    @init_population.setBestSolution
  end

  def start
    @populations = [@init_population]
    @iterations.times do |i|
      selected_solutions = selection(@populations[i].solutions)
      crossover_solutions = crossover(selected_solutions)
      mutated_solutions = mutation(crossover_solutions)

      mutated_solutions.each do |solution|
        solution.test(@init_population.plan)
      end
      
      new_solutions = reinsertion(i, @populations[i].solutions, mutated_solutions)
      
      new_population = Population.new(new_solutions, @init_population.plan)
      new_population.setBestSolution
      new_population.setFitnessAverage
      
      puts "Generation: " + i.to_s
      print(new_population.solutions)
      @populations.push(new_population)
    end
  end

  def print(solutions)
    solutions.each do |solution|
      puts solution.fitness
    end
  end

  def generateCSV
    lines = [["n,best,average"]]
    @populations.each_with_index do |population, i|
      element = i.to_s + "," + population.best.fitness.to_s + "," + population.average.to_s
      lines.push(element)
    end
    output = @iterations.to_s + "-G_K:" + @k.to_s + "_Plan:" + @init_population.plan + ".csv"
    File.open(output, "w") { |f| f.puts(lines) }
  end

  def populations
    return @populations
  end

  def selection(solutions)
    selected_solutions = []
    solutions.length.times do
      select = []
      @k.times do
        select.push(solutions[rand(0..solutions.length-1)])
      end

      best = select[0]
      for j in 1..(@k-1)
        if best.fitness > select[j].fitness
          best = select[j]
        end
      end

      best = Solution.new(best.doors)
      selected_solutions.push(best)
    end
    return selected_solutions
  end

  def crossover(solutions)
    number_parents = Integer(@pc * solutions.length)

    parents = []
    randoms = []
    number_parents.times do
      begin
        random = rand(0..solutions.length-1)
      end while randoms.include?random
      randoms.push(random)
      parents.push([solutions[random],random])
    end

    (0..number_parents-1).step(2) do |i|
      pcc = rand(1..4)

      children_doors = parents[i][0].doors[0..pcc-1] + parents[i+1][0].doors[pcc..4]
      new_solution = Solution.new(children_doors)
      solutions[parents[i][1]] = new_solution

      children_doors = parents[i+1][0].doors[0..pcc-1] + parents[i][0].doors[pcc..4]
      new_solution = Solution.new(children_doors)
      solutions[parents[i+1][1]] = new_solution
    end
    return solutions
  end

  def mutation(solutions)
    number_mutations = Integer(solutions.length * @pm)

    randoms = []
    number_mutations.times do
      pcm = rand(0..4)

      begin
        random = rand(0..solutions.length-1)
      end while randoms.include?random
      randoms.push(random)

      randomSolution = solutions[random]
      external_walls = Patches.new(@init_population.plan).getExternalWalls()

      begin
        randomEW = rand(0..external_walls.length-1)
        selectedEW = Door.new(external_walls[randomEW][0], external_walls[randomEW][1])
      end while randomSolution.isDoorIn(selectedEW)

      randomSolution.doors[pcm] = selectedEW

      solutions[random] = Solution.new(randomSolution.doors)
    end
    return solutions
  end

  def reinsertion(i, old_solutions, new_solutions)
    if i < @iterations - 5
      return new_solutions
    else
      combination = old_solutions + new_solutions
      sort_array = []
      combination.each do |solution|
        sort_array.push([solution,solution.fitness])		
      end
      sorted = sort_array.sort {|a,b| a[1] <=> b[1]}

      return sorted.take(20).map { |e| e[0] }
    end
  end
end

