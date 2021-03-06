require 'rubygame'
require 'canvas'

class Visual

  attr_accessor :frame

  def self.attributes
    { :width   => 640,
      :height  => 400,
      :title   => 'Visual',
      :bgcolor => '#602020',
      :fps     => 50,
      :framedump => nil }
  end

  attributes.keys.each do |attr|
    define_singleton_method attr do |value = nil, &block|
      instance_variable_set "@#{attr}", block || value
    end
  end

  Canvas.instance_methods(false).each do |method|
    define_method(method) do |*args|
      @surface.send(method, *args)
    end
  end

  def initialize(options = {})
    self.class.attributes.each do |key, default|
      value = options[key]
      value = self.class.instance_variable_get("@#{key}") if value.nil?
      value = (default.is_a?(Proc) ? default.call : default) if value.nil?
      instance_variable_set "@#{key}", value
    end
    init if respond_to? :init
  end

  def self.run
    @title ||= name
    new.run
  end

  def run
    setup_screen
    setup_event_queue
    setup_clock

    @frame = 0
    @pause = false

    loop do
      @queue.each { |event| handle_event(event) }
      if !@pause || @step
        update
        if @step
          @step = false
        end
      end
      @clock.tick
    end
  end

  def update
    @surface.clear true
    draw if respond_to? :draw
    @surface.flip
    if @framedump && @frame < @framedump[:count]
      if @framedump[:every].nil? || (@frame % @framedump[:every] == 0)
        @surface.savebmp "#{@framedump[:path]}/frame-#{'%04d' % @frame}.bmp"
      end
    end
    @frame += 1
  end

  def handle_event(event)
    case event
    when Rubygame::Events::KeyPressed
      case event.key
      when :escape
        quit
      when :p
        @pause = !@pause
      when :space
        @step = true
      end
    when Rubygame::Events::QuitRequested
      quit
    end
  end

  def quit
    Rubygame.quit
    exit
  end

  private

  def setup_screen
    @surface = Canvas.new(width: @width, height: @height, bgcolor: @bgcolor)
  end

  def setup_event_queue
    @queue = Rubygame::EventQueue.new
    @queue.enable_new_style_events
  end

  def setup_clock
    @clock = Rubygame::Clock.new
    @clock.target_framerate = @fps
  end

end
