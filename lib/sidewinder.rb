class Sidewinder < Algorithm

  def run
    each_row do |row|
      run = []
      row.each do |cell|
        puts "Visiting cell #{cell.coords}" if $debug
        run << cell
        if cell.east.nil? || (cell.north && rand(2).zero?)
          member = run.sample
          member.link member.north if member.north
          run.clear
        else
          cell.link cell.east
        end
      end
    end
  end
end
