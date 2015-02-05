class BinaryTree < Algorithm

  def run
    each_cell do |cell|
      puts "Visiting cell #{cell.coords}" if $debug
      neighbors = [cell.north, cell.east].compact
      puts "  Neighbors #{neighbors.map(&:coords).join ', '}" if $debug
      other = neighbors.sample
      cell.link(other) if other
    end
  end
end
