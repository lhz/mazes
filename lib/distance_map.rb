class DistanceMap

  def initialize(root)
    @root  = root
    @cells = {}
    @cells[@root] = 0
  end

  def [](cell)
    @cells[cell]
  end

  def []=(cell, distance)
    @cells[cell] = distance
  end

  def cells
    @cells.keys
  end

  def path_to(goal)
    current = goal

    breadcrumbs = DistanceMap.new(@root)
    breadcrumbs[current] = @cells[current]

    until current == @root
      current.links.each do |neighbor|
        if @cells[neighbor] < @cells[current]
          breadcrumbs[neighbor] = @cells[neighbor]
          current = neighbor
          break
        end
      end
    end

    breadcrumbs.cells.each { |c| c[:breadcrumb] = true }

    breadcrumbs.cells[1..-1] << breadcrumbs.cells[0]
  end

  def max
    max_cell, max_dist = @root, 0
    @cells.each do |cell, dist|
      max_cell, max_dist = cell, dist if dist > max_dist
    end
    [max_cell, max_dist]
  end
end
