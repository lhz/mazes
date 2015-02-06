require 'algorithm'

class HuntAndKill < Algorithm

  def run
    puts "Running #{self.class} algorithm." if $debug

    current = grid.random_cell
    while current
      unvisited_neighbors = current.neighbors.select { |n| n.links.empty? }
      if unvisited_neighbors.any?
        neighbor = unvisited_neighbors.sample
        current.link(neighbor)
        current = neighbor
      else
        current = nil
        grid.each_cell do |cell|
          visited_neighbors = cell.neighbors.select { |n| n.links.any? }
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
