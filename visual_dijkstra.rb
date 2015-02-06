#!/usr/bin/env ruby

$: << './lib'

require 'mazes'
require 'visual'

class Dijkstra < Visual
  include Math

  width  660
  height 660
  bgcolor '#808080'
  fps 5

  def init
    @grid = ColoredGrid[39, 39]
    RecursiveBacktracker.on @grid
    @path = @grid.find_longest_path
    # puts @path.map(&:coords).join '-'
  end

  def draw
    gc = '#000000'
    pc = '#000000'
    gw = 16
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

    @path.each_cons(2) do |a, b|
      next unless a.linked?(b)
      co = gw / 2
      x1, y1 = x0 + gw * a.col + co, y0 + gw * a.row + co
      x2, y2 = x0 + gw * b.col + co, y0 + gw * b.row + co
      if x1 != x2
        x1, x2 = [x1, x2].minmax
        (x1..x2).step(4) do |x|
          rectangle from: [x, y1], to: [x - 1, y1 - 1], color: pc
        end
      else
        y1, y2 = [y1, y2].minmax
        (y1..y2).step(4) do |y|
          rectangle from: [x1, y], to: [x1 - 1, y - 1], color: pc
        end
      end
    end
    @path.values_at(0, -1).each do |c|
      co = gw / 2
      x1, y1 = x0 + gw * c.col + co, y0 + gw * c.row + co
      circle center: [x1, y1], radius: 4, fill: '#ff0000'
    end
  end
end

Dijkstra.run
