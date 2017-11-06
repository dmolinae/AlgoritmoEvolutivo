class Patches
  def initialize(file)
    @patches = []
    File.open(file, "r") do |f|
      f.each_line do |line|
        @patches.push(line.split(" "))
      end
    end
  end
  
  def getType(x, y)		
    @patches.each do |patch|		
      if Integer(patch[0]) == x and Integer(patch[1]) == y
        return Integer(patch[2])
      end
    end
  end

  def getExternalWalls()
    external_walls = []
    @patches.each do |patch|
      types = [] # para almacenar el tipo encontrado de patch
      if patch[2] == "64"
        # comprobar punto a la izquierda
        x = Integer(patch[0]) - 1
        y = Integer(patch[1])
        types.push(getType(x,y))
        # comprobar punto a la derecha
        x = Integer(patch[0]) + 1
        y = Integer(patch[1])
        types.push(getType(x,y))
        # comprobar punto arriba
        x = Integer(patch[0])
        y = Integer(patch[1]) + 1
        types.push(getType(x,y))
        # comprobar punto abajo
        x = Integer(patch[0])
        y = Integer(patch[1]) - 1
        types.push(getType(x,y))

        if types.include?(0) and types.include?(2)
          external_walls.push(patch)
        end
      end
    end
    return external_walls
  end
end

class Door
  def initialize(x,y)
    @x = x
    @y = y
  end

  def self.getDoors(file)
    doors = []
    File.open(file, "r") do |f|
      f.each_line do |line|
        door = line.split(" ")
        doors.push(Door.new(door[0],door[1]))
      end
    end
    return doors
  end

  def x
    return @x
  end

  def y
    return @y
  end
end

class Solution
  def initialize(doors = [], fitness = 0)
    @doors = doors
    @fitness = fitness
  end

  def generateFromExternalWalls(external_walls)
    @doors = []
    5.times do
      random = rand(0..external_walls.length-1)
      @doors.push(Door.new(external_walls[random][0], external_walls[random][1]))
    end
    return self
  end

  def generateFile(output)
    doors = []
    for i in 0..4
      element = @doors[i].x + " " + @doors[i].y
      doors.push(element)
    end
    File.open(output, "w") { |f| f.puts(doors) }
  end

  def getData(file)
    data = []
    File.open(file, "r") do |f|
      f.each_line do |line|
        data.push(line.split(" "))
      end
    end
    return data
  end

  def test
    generateFile("doors.plan")
    system(
      "./netlogo-headless.sh --model escape4_v6.nlogo --experiment simulation --table -")
    @fitness = getData("seconds.output")[0]
  end

  def doors
    return @doors
  end

  def fitness
    return @fitness
  end
end

class Population
  def initialize(solutions = [])
    @solutions = solutions
  end

  def fromFile(file, size)
    @solutions = []
    external_walls = Patches.new(file).getExternalWalls()
    size.times do
      solution = Solution.new.generateFromExternalWalls(external_walls)
      solution.test
      @solutions.push(solution)
    end
    return self
  end

  def generateFile
    File.open('population.txt', 'w') {|f| f.write(Marshal.dump(@solutions)) } 
  end

  def load(file)
    @solutions = Marshal.load(File.read(file))
    return self
  end

  def solutions
    return @solutions
  end
end
