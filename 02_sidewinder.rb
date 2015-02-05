#!/usr/bin/env ruby

$: << './lib'
require 'maze'

maze = Maze.new(12, 12)

maze.height.times do |y|
  run_first = 0
  maze.width.times do |x|
    heads = (rand < 0.5)
    if (heads || x == (maze.width - 1)) && y > 0
      maze[y, run_first + rand(x - run_first + 1)].open_north
      run_first = x + 1
    elsif x < maze.width - 1
      maze[y, x].open_east
    end
  end
end

puts maze
