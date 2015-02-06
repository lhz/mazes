require 'grid'
require 'rubygame'

class ColoredGrid < Grid
  attr_accessor :distances

  def distances=(distances)
    @distances = distances
    farthest, @maximum = distances.max
  end

  def background_color_for(cell)
    distance = @distances[cell] or return nil
    v = (@maximum - distance) / @maximum.to_f
    v = v * 0.85 + 0.15
    hsl = Rubygame::Color::ColorHSL.new([0.4, 0.5, v])
    Rubygame::Color::ColorRGB.new(hsl.to_rgba_ary)
  end
end
