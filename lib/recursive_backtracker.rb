require 'algorithm'

class RecursiveBacktracker < Algorithm

  def run
    puts "Running #{self.class} algorithm." if $debug

    stack = [random_cell]
    while stack.any?
      current = stack.last
      neighbors = current.unvisited_neighbors
      if neighbors.empty?
        stack.pop
      else
        neighbor = neighbors.sample
        current.link neighbor
        stack.push neighbor
      end
    end
  end
end
