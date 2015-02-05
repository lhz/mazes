#!/usr/bin/env ruby

$: << './lib'

require 'distance_grid'
require 'sidewinder'

grid = DistanceGrid[9, 15]

Sidewinder.on(grid)

grid.distances = grid[0, 0].distances

puts grid
