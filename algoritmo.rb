#!/usr/bin/env ruby
# encoding: utf-8

def getTypeOfPatch(patches, x, y)
  patches.each do |patch|
    if Integer(patch[0]) == x and Integer(patch[1]) == y
      return Integer(patch[2])
    end
  end
end

#ubicar al azar 5 paredes
def generateDoors(external_walls)
  doors = []
  for i in 0..4
    random = rand(0..external_walls.length-1)
	  element = external_walls[random][0] + " " + external_walls[random][1]
    doors.push(element)
  end
  File.open("doors.plan", "w") { |f| f.puts(doors) }
end

def getPatchesFromFile(file)
  patches = []
  File.open(file, "r") do |f|
    f.each_line do |line|
      patches.push(line.split(" "))
    end
  end
  return patches
end

def getExternalWalls(patches)
  external_walls = []
  patches.each do |patch|
    types = [] # para almacenar el tipo encontrado de patch
    if patch[2] == "64"
      # comprobar punto a la izquierda
      x = Integer(patch[0]) - 1
      y = Integer(patch[1])
      types.push(getTypeOfPatch(patches,x,y))
      # comprobar punto a la derecha
      x = Integer(patch[0]) + 1
      y = Integer(patch[1])
      types.push(getTypeOfPatch(patches,x,y))
      # comprobar punto arriba
      x = Integer(patch[0])
      y = Integer(patch[1]) + 1
      types.push(getTypeOfPatch(patches,x,y))
      # comprobar punto abajo
      x = Integer(patch[0])
      y = Integer(patch[1]) - 1
      types.push(getTypeOfPatch(patches,x,y))

      if types.include?(0) and types.include?(2)
        external_walls.push(patch)
      end
    end
  end
  return external_walls
end

patches = getPatchesFromFile("school.plan")
external_walls = getExternalWalls(patches)
generateDoors(external_walls)
