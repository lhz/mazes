require 'forwardable'

class Algorithm
  extend Forwardable

  attr_accessor :grid

  def_delegators :@grid, :each_row, :each_cell

  def self.[](height, width = height)
    on Grid[height, width]
  end

  def self.on(grid)
    algo = new(grid)
    algo.run
    algo.grid
  end

  def initialize(grid)
    @grid = grid
  end

  def run
    raise "#{self.class} does not implement the :run method."
  end
end
