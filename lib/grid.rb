# coding: utf-8
require 'cell'

class Grid
  attr_reader :rows, :cols

  def self.[](rows, cols)
    new rows, cols
  end

  def initialize(rows, cols, opts = {})
    @rows = rows
    @cols = cols
    @grid = prepare_grid
    configure_cells
  end

  def [](row, col)
    return nil unless row.between?(0, rows - 1)
    return nil unless col.between?(0, cols - 1)
    @grid[row][col]
  end

  def prepare_grid
    Array.new(rows) do |row|
      Array.new(cols) do |col|
        Cell.new row, col
      end
    end
  end

  def configure_cells
    each_cell do |cell|
      cell.north = self[cell.row - 1, cell.col]
      cell.south = self[cell.row + 1, cell.col]
      cell.west  = self[cell.row, cell.col - 1]
      cell.east  = self[cell.row, cell.col + 1]
    end
  end

  def find_longest_path
    dist = random_cell.distances
    cell, _ = dist.max
    dist = cell.distances
    goal, dmax = dist.max
    self.distances = goal.distances
    dist.path_to(goal)
  end
  
  def each_row
    @grid.each do |row|
      yield row
    end
  end

  def each_cell
    each_row do |row|
      row.each do |cell|
        yield cell if cell
      end
    end
  end

  def size
    rows * cols
  end

  def random_cell
    @grid.flatten.sample
  end

  def deadends
    @grid.flatten.select(&:deadend?)
  end

  def contents_of(cell)
    '   '
  end

  def to_s(mode = :ascii)
    [:ascii, :roguelike].include?(mode) or
      raise "Invalid mode: #{mode}"
    send "to_#{mode}"
  end

  def to_ascii
    str = '+' << '---+' * cols << "\n"
    each_row do |row|
      body, foot = '¦', '+'
      row.each do |cell|
        cell = Cell.new(-1, -1) unless cell
        c = contents_of(cell)
        body << (cell.linked?(cell.east)  ? "#{c} " : "#{c}¦")
        foot << (cell.linked?(cell.south) ? '   +' : '---+')
      end
      str << body << "\n" << foot << "\n"
    end
    str
  end

  def to_roguelike
    str = '#' << '###' * cols << "\n"
    each_row do |row|
      body, foot = '#', '#'
      row.each do |cell|
        cell = Cell.new(-1, -1) unless cell
        body << (cell.linked?(cell.east)  ? '   ' : '  #')
        foot << (cell.linked?(cell.south) ? '  #' : '###')
      end
      str << body << "\n" << foot << "\n"
    end
    str
  end
end
