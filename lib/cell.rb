class Cell
  def initialize
    @north_wall = true
    @east_wall  = true
  end

  def open_north
    @north_wall = false
  end

  def open_east
    @east_wall = false
  end

  def north_wall?
    @north_wall
  end

  def east_wall?
    @east_wall
  end
end
