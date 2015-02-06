#!/usr/bin/env ruby

$: << './lib'

require 'colored_grid'
require 'sidewinder'
require 'aldous_broder'
require 'wilson'
require 'hunt_and_kill'
require 'visual'

class Dijkstra < Visual
  include Math

  width  500
  height 500
  bgcolor '#808080'
  fps 5

  def init
    @grid = ColoredGrid[39, 39]
    # Sidewinder.on @grid
    HuntAndKill.on @grid
    # @grid.distances = @grid[@grid.rows / 2, @grid.cols / 2].distances
    @grid.find_longest_path
  end

  def draw
    # col = (19.49 + 19.49 * cos(PI * frame / 32.0)).floor
    # row = (19.49 + 19.49 * sin(PI * frame / 32.0)).floor
    # @grid.distances = @grid[row, col].distances

    gc = '#000000'
    gw = 12
    x0 = (width  - gw * @grid.cols) / 2
    y0 = (height - gw * @grid.rows) / 2
    @grid.each_row do |row|
      row.each do |cell|
        cell = Cell.new(-1, -1) unless cell
        x1, y1 = x0 + gw * cell.col, y0 + gw * cell.row
        x2, y2 = x0 + gw * (cell.col + 1), y0 + gw * (cell.row + 1)
        bg = @grid.background_color_for(cell)
        rectangle from: [x1 + 1, y1 + 1], to: [x2, y2], fill: bg
        unless cell.north
          line from: [x1, y1], to: [x2, y1], color: gc
          line from: [x1, y1 + 1], to: [x2, y1 + 1], color: gc
        end
        unless cell.linked?(cell.east)
          line from: [x2, y1], to: [x2, y2], color: gc
          line from: [x2 - 1, y1], to: [x2 - 1, y2], color: gc
        end
        unless cell.linked?(cell.south)
          line from: [x2, y2], to: [x1, y2], color: gc
          line from: [x2, y2 - 1], to: [x1, y2 - 1], color: gc
        end
        unless cell.west
          line from: [x1, y2], to: [x1, y1], color: gc
          line from: [x1 + 1, y2], to: [x1 + 1, y1], color: gc
        end
      end
    end
    # x1, y1 = x0 + gw * col, y0 + gw * row
    # x2, y2 = x0 + gw * (col + 1), y0 + gw * (row + 1)
    # circle center: [x1 + 5, y1 + 5], radius: 3, fill: '#000000'
  end
end

Dijkstra.run
