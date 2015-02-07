require 'chunky_png'

class Mask
  def self.from_txt(file)
    lines = File.readlines(file).map { |line| line.strip } 
    lines.pop while lines.last.length < 1 

    rows = lines.length 
    cols = lines.first.length 

    Mask.new(rows, cols).tap do |mask|
      mask.rows.times do |row| 
        mask.cols.times do |col|
          masked = (lines[row][col] == "X")
          mask[row, col] = !masked
        end
      end
    end
  end

  def self.from_png(file)
    image = ChunkyPNG::Image.from_file(file) 
    Mask.new(image.height, image.width).tap do |mask|
      mask.rows.times do |row| 
        mask.cols.times do |col|
          masked = (image[col, row] == ChunkyPNG::Color::BLACK)
          mask[row, col] = !masked
        end
      end
    end
  end

  attr_reader :rows, :cols

  def initialize(rows, cols)
    @rows, @cols = rows, cols
    @bits = Array.new(@rows) { Array.new(@cols, true) }
  end

  def [](row, col)
    if row.between?(0, @rows - 1) && col.between?(0, @cols - 1)
      @bits[row][col]
    else
      false
    end
  end

  def []=(row, col, is_on)
    @bits[row][col] = is_on
  end

  def count
    count = 0
    @rows.times do |row|
      @cols.times do |col|
        count += 1 if @bits[row][col]
      end
    end
    count
  end

  def random_location
    loop do
      row = rand(@rows)
      col = rand(@cols)
      return [row, col] if @bits[row][col]
    end
  end
end
