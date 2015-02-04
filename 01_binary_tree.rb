#!/usr/bin/env ruby

$: << './lib'

require 'maze'

maze = Maze.new(12, 12)

maze.height.times do |y|
  maze.width.times do |x|
    heads = (rand < 0.5)
    cell = maze[y, x]
    if x < maze.width - 1 && y > 0
      heads ? cell.open_north : cell.open_east
    elsif x < maze.width - 1
      cell.open_east
    elsif y > 0
      cell.open_north
    end
  end
end

puts maze.drawing

