require 'algorithm'

class AldousBroder < Algorithm

  def run
    puts "Running #{self.class} algorithm." if $debug

    cell = grid.random_cell
    unvisited = grid.size - 1

    while unvisited > 0
      neighbor = cell.neighbors.sample

      if neighbor.links.empty?
        cell.link(neighbor)
        unvisited -= 1
      end

      cell = neighbor
    end
  end
end
