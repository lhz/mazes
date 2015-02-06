require 'rubygame'

class Canvas < Rubygame::Screen

  attr_accessor :bgcolor, :surface, :width, :height, :title

  def initialize(options = {})
    @width   = options.fetch(:width,  640)
    @height  = options.fetch(:height, 400)
    @title   = options.fetch(:title,  'Canvas')
    @bgcolor = options[:bgcolor] || '#00ff00'
    @surface = Rubygame::Surface.new([width, height],
      0, [Rubygame::HWSURFACE])
    super([width, height],
      0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
  end

  def flip
    surface.blit self, [0, 0]
    super
  end

  def parse_color(value)
    case value
    when String
      r, g, b = value.downcase.scan(/[0-9a-f]{2}/).map do |h|
        h.to_i(16) / 255.0
      end
      Rubygame::Color::ColorRGB.new([r, g, b])
    when Rubygame::Color::ColorRGB, Rubygame::Color::ColorHSL
      value
    end
  end

  def draw_rect(xpos, ypos, width, height, color)
    surface.draw_box([xpos, ypos],
      [xpos + width - 1, ypos + height - 1],
      parse_color(color))
  end

  def fill_rect(xpos, ypos, width, height, color)
    surface.draw_box_s([xpos, ypos],
      [xpos + width - 1, ypos + height - 1],
      parse_color(color))
  end

  def set_pixel(xpos, ypos, color)
    surface.set_at([xpos, ypos], parse_color(color))
  end

  def rectangle(args)
    x0, y0 = args[:from]
    if args[:to]
      x1, y1 = args[:to]
    else
      x1 = x0 + (args[:w] || args[:width]) - 1
      y1 = y0 + (args[:h] || args[:height]) - 1
    end
    if args[:fill]
      fill_rect(x0, y0, x1-x0+1, y1-y0+1, args[:fill])
    else
      draw_rect(x0, y0, x1-x0+1, y1-y0+1, args[:color])
    end
  end

  def polygon(args)
    points = args[:points]
    if args[:fill]
      surface.draw_polygon_s(points, parse_color(args[:fill]))
    else
      surface.draw_polygon(points, parse_color(args[:color]))
    end
  end

  def draw_circle(xpos, ypos, radius, color)
    surface.draw_circle([xpos + radius, ypos + radius],
      radius, parse_color(color))
  end

  def fill_circle(xpos, ypos, radius, color)
    surface.draw_circle_s([xpos + radius, ypos + radius],
      radius, parse_color(color))
  end

  def draw_arc(xpos, ypos, radius, angle1, angle2, color)
    surface.draw_arc([xpos + radius, ypos + radius],
      radius, [angle1, angle2], parse_color(color))
  end

  def fill_arc(xpos, ypos, radius, angle1, angle2, color)
    surface.draw_arc_s([xpos + radius, ypos + radius],
      radius, [angle1, angle2], parse_color(color))
  end

  def circle(args)
    x, y = args[:center]
    r = args[:radius]
    x -= r
    y -= r
    if args[:fill]
      fill_circle(x, y, r, args[:fill])
    else
      draw_circle(x, y, r, args[:color])
    end
  end

  def arc(args)
    x, y = args[:center]
    a, b = args[:angles]
    r = args[:radius]
    x -= r
    y -= r
    if args[:fill]
      fill_arc(x, y, r, a, b, args[:fill])
    else
      draw_arc(x, y, r, a, b, args[:color])
    end
  end

  def draw_line(x0, y0, x1, y1, color)
    surface.draw_line([x0, y0], [x1, y1], parse_color(color))
  end

  def line(args)
    x0, y0 = args[:from]
    x1, y1 = args[:to]
    draw_line(x0, y0, x1, y1, args[:color])
  end

  def plot(args)
    x, y = args[:at]
    set_pixel(x, y, args[:color])
  end

  def clear(include_border = true)
    surface.draw_box_s([0, 0], [width - 1, height - 1],
      parse_color(bgcolor))
  end
end
