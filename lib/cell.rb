require 'distance_map'

class Cell
  attr_reader   :row, :col
  attr_accessor :north, :south, :east, :west

  def initialize(row, col)
    @row   = row
    @col   = col
    @links = {}
    @info  = {}
  end

  def [](key)
    @info[key]
  end

  def []=(key, value)
    @info[key] = value
  end

  def coords
    "(%d,%d)" % [row, col]
  end

  def link(other, bidirectional = true)
    puts "  Linking cells #{coords} and #{other.coords}." if $debug && bidirectional
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

  def deadend?
    links.size == 1
  end

  def visited?
    links.any?
  end

  def unvisited?
    !visited?
  end

  def neighbors
    [north, south, east, west].compact
  end

  def visited_neighbors
    neighbors.select &:visited?
  end

  def unvisited_neighbors
    neighbors.select &:unvisited?
  end

  def distances
    @distances ||= DistanceMap.new(self).tap do |dmap|
      frontier = [self]
      while frontier.any?
        frontier = frontier.flat_map do |cell|
          cell.links.map do |neighbor|
            if dmap[neighbor]
              nil
            else
              dmap[neighbor] = dmap[cell] + 1
              neighbor
            end
          end
        end.compact
      end
    end
  end
end
