require 'cell'

class Maze
  attr_reader :width, :height, :cells

  def initialize(width, height)
    @width  = width
    @height = height
    @cells  = Array.new(@height * @width) { Cell.new }
  end

  def [](row, column)
    if row >=0 && row < height && column >= 0 && column < width
      cells[row * width + column]
    else
      Cell.new.tap do |c|
        c.open_north if column < 0 || column >= width
        c.open_east  if row < 0 || row >= height
      end
    end
  end

  def to_s(mode = :unicode)
    case mode
    when :unicode then to_unicode
    else to_ascii
    end
  end

  def to_ascii
    result = ''
    cells.each_slice(width).with_index do |row, y|
      result << (y > 0 ? "\u251C" : "\u250C")
      row.each do |cell|
        if y.zero?
          ec = (cell == row[-1] ? "\u2510" : "\u252C")
          result << (cell.north_wall? ? "\u2500\u2500#{ec}" : "  #{ec}")
        else
          ec = (cell == row[-1] ? "\u2502" : "\u253C")
          result << (cell.north_wall? ? "\u2500\u2500#{ec}" : "  #{ec}")
        end
      end
      result << "\n"

      result << "\u2502"
      row.each do |cell|
        result << (cell.east_wall? ? "  \u2502" : '   ')
      end
      result << "\n"
    end
    result << "\u2514#{"\u2500\u2500\u2534" * (width - 1 )}\u2500\u2500\u2518"
    result
  end

  def to_unicode
    result = ""
    height.times.each do |y|
      width.times.each do |x|
        result << char_ul(y, x) << char_uc(y, x) * 3
      end
      result << char_ul(y, width) << "\n"
      width.times.each do |x|
        result << char_ml(y, x) << "   "
      end
      result << char_ml(y, width) << "\n"
    end
    width.times.each do |x|
      result << char_ul(height, x) << char_uc(height, x) * 3
    end
    result << char_ul(height, width) << "\n"
    result
  end

  def char_ul(y, x)
    a, b, c = self[y - 1, x - 1], self[y, x - 1], self[y, x]
    n = (a.east_wall? ? 0 : 8) +
      (b.north_wall?  ? 0 : 4) +
      (b.east_wall?   ? 0 : 2) +
      (c.north_wall?  ? 0 : 1)
    chars[n]
  end

  def char_uc(y, x)
    a = self[y, x]
    n = (a.north_wall? ? 10 : 15)
    chars[n]
  end

  def char_ml(y, x)
    a = self[y, x - 1]
    n = (a.east_wall? ? 5 : 15)
    chars[n]
  end

  def chars_thin
    @chars ||= [
      "\u253C", "\u2524", "\u2534", "\u2518",
      "\u251C", "\u2502", "\u2514", "\u2575",
      "\u252C", "\u2510", "\u2500", "\u2574",
      "\u250C", "\u2577", "\u2576",      " "
    ]
  end

  def chars
    @chars ||= [
      "\u254B", "\u252B", "\u253B", "\u251B",
      "\u2523", "\u2503", "\u2517", "\u2579",
      "\u2533", "\u2513", "\u2501", "\u2578",
      "\u250F", "\u257B", "\u257A",      " "
    ]
  end
end
