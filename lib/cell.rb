class Cell
  attr_reader   :row, :col
  attr_accessor :north, :south, :east, :west

  def initialize(row, col)
    @row   = row
    @col   = col
    @links = {}
  end

  def coords
    "(%d,%d)" % [row, col]
  end

  def link(other, bidirectional = true)
    puts "Linking cells #{coords} and #{other.coords}." if $debug
    @links[other] = true
    other.link(self, false) if bidirectional
    self
  end

  def unlink(other, bidirectional = true)
    @links.delete(other)
    other.unlink(self, false) if bidirectional
    self
  end

  def links
    @links.keys
  end

  def linked?(other)
    @links.key? other
  end

  def neighbors
    [north, south, east, west].compact
  end
end
