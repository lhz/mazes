#!/usr/bin/env ruby

$: << './lib'

require 'mazes'
require 'visual'

class Masked < Visual
  include Math

  width  936
  height 200
  bgcolor '#808080'
  fps 5

  def init
    mask = Mask.from_png('masks/offence1.png')

    1.times do |i|
      srand 632 # seed 632 (length 911)
      # print "."
      grid = MaskedGrid.new(mask)
      RecursiveBacktracker.on grid
      entrance = grid[14, 0]
      exitcell = grid[18, 112]
      dist_map = entrance.distances
      path     = dist_map.path_to(exitcell)
      if @path.nil? || path.size > @path.size
        @seed = i
        @grid = grid
        @path = path
        @entrance = entrance
        @exit = exitcell
      end
    end
    
    puts " Seed #{@seed}, Path length: #{@path.size}"
  end

  def draw
    gc = '#000000'
    pc = '#000000'
    gw = 8
    x0 = (width  - gw * @grid.cols) / 2
    y0 = (height - gw * @grid.rows) / 2

    [:bg, :fg].each do |pass|
      @grid.each_cell do |cell|
        cell = Cell.new(-1, -1) unless cell
        x1, y1 = x0 + gw * cell.col, y0 + gw * cell.row
        x2, y2 = x0 + gw * (cell.col + 1), y0 + gw * (cell.row + 1)
        if pass == :bg
          if cell == @entrance
            bg = '#C0F0C0'
          elsif cell == @exit
            bg = '#F0C0C0'
          elsif @path.include?(cell)
            bg = '#C0C0F0'
          else
            bg = '#F0F0F0'
          end
          rectangle from: [x1, y1], to: [x2, y2], fill: bg
        else
          unless cell.north
            line from: [x1, y1], to: [x2, y1], color: gc
          end
          unless cell.linked?(cell.east) || cell == @exit
            line from: [x2, y1], to: [x2, y2], color: gc
          end
          unless cell.linked?(cell.south)
            line from: [x2, y2], to: [x1, y2], color: gc
          end
          unless cell.west || cell == @entrance
            line from: [x1, y2], to: [x1, y1], color: gc
          end
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
        (x1..x2).step(2) do |x|
          rectangle from: [x, y1], to: [x, y1], color: pc
        end
      else
        y1, y2 = [y1, y2].minmax
        (y1..y2).step(2) do |y|
          rectangle from: [x1, y], to: [x1, y], color: pc
        end
      end
    end
    # co = gw / 2
    # x1, y1 = x0 + gw * @entrance.col + co, y0 + gw * @entrance.row + co
    # circle center: [x1, y1], radius: 2, fill: '#60f060'
    # x1, y1 = x0 + gw * @exit.col + co, y0 + gw * @exit.row + co
    # circle center: [x1, y1], radius: 2, fill: '#60f060'
  end
end

Masked.run
