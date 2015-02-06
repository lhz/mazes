require 'algorithm'

class HuntAndKill < Algorithm

  def run
    puts "Running #{self.class} algorithm." if $debug

    current = grid.random_cell
    while current
      unvisited_neighbors = current.unvisited_neighbors
      if unvisited_neighbors.any?
        neighbor = unvisited_neighbors.sample
        current.link(neighbor)
        current = neighbor
      else
        current = nil
        grid.each_cell do |cell|
          visited_neighbors = cell.visited_neighbors
          if cell.links.empty? && visited_neighbors.any?
            current = cell
            neighbor = visited_neighbors.sample
            current.link(neighbor)
            break
          end
        end
      end
    end
  end
end
