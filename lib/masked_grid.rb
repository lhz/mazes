require 'grid'

class MaskedGrid < ColoredGrid
  attr_reader :mask

  def initialize(mask)
    @mask = mask
    super(@mask.rows, @mask.cols)
  end

  def prepare_grid
    Array.new(rows) do |row|
      Array.new(cols) do |col|
        Cell.new(row, col) if @mask[row, col] 
      end
    end
  end

  def random_cell
    row, col = @mask.random_location
    self[row, col]
  end

  def size
    @mask.count
  end
end
