require 'bundler'
Bundler.require
require 'tkextlib/tile'
require 'tkextlib/tcllib'

app = TkRoot.new {
  title "Node experiment"
  geometry "600x600"
}

# canvas = TkCanvas.new(app)
# canvas.pack(fill: 'both', expand: true)

# canvas.bind('Button-1') do |event|
#   place_node_widget(event.x, event.y)
# end

# def place_node_widget(x, y)
#   widget = NodeWidget.new(canvas)
#   widget.place(x, y)
# end


# class NodeWidget
#   attr_reader :canvas, :center, :text

#   def initialize(canvas)
#     @canvas = canvas
#     @center = []
#     @width = 100
#     @height = 40
#     @font = TkFont.new(family: 'Helvetica', size: 14)
#     @text = 'Hello'
#     @label = Tk::Tile::Label.new(canvas, text: @text, font: @font)
#   end

#   def place(x, y)
#     @label.
#   end
# end
require_relative 'canvas_extension'
class TkCanvas
  include TkCanvasExtensions
end# Custom Canvas Widget
class CustomCanvas < TkCanvas
  def initialize(parent)
    super(parent)
    @selected_node = nil
    @font = TkFont.new(family: 'Helvetica', size: 14)
    bind_events
  end

  def bind_events
    bind('1', proc { |e| on_single_click(e) }) # Single click event
    bind('Double-1', proc { |e| on_double_click(e) }) # Double click event
  end

  def on_single_click(event)
    x1, y1 = event.x, event.y
    x2, y2 = x1 + 100, y1 + 50 # Default size for the rounded rectangle
    @rect_id = create_rounded_rectangle(x1, y1, x2, y2, radius: 10)
  end

  def on_double_click(event)
    return unless @rect_id
    create_text_field(event.x, event.y)
  end

  def create_rounded_rectangle(x1, y1, x2, y2, radius:)
    create_arc(x1, y1, x1 + 2 * radius, y1 + 2 * radius, start: 90, extent: 90, style: 'arc')
    create_arc(x2 - 2 * radius, y1, x2, y1 + 2 * radius, start: 0, extent: 90, style: 'arc')
    create_arc(x2 - 2 * radius, y2 - 2 * radius, x2, y2, start: 270, extent: 90, style: 'arc')
    create_arc(x1, y2 - 2 * radius, x1 + 2 * radius, y2, start: 180, extent: 90, style: 'arc')
    create_line(x1 + radius, y1, x2 - radius, y1)
    create_line(x1 + radius, y2, x2 - radius, y2)
    create_line(x1, y1 + radius, x1, y2 - radius)
    create_line(x2, y1 + radius, x2, y2 - radius)
  end

  def create_text_field(x, y)
    text_field = TkEntry.new(self)
    text_field.place('x' => x, 'y' => y)
    @text_id = text_field

    text_field.bind('Return', proc { adjust_rectangle_to_text(text_field.get, x, y) })
    text_field.focus
  end

  def adjust_rectangle_to_text(text, x, y)
    delete(@rect_id) if @rect_id
    text_width = @font.measure(text)
    text_height = @font.metrics('linespace')
    x1, y1 = x, y
    x2, y2 = x1 + text_width, y + text_height
    @rect_id = create_rounded_rectangle(x1, y1, x2, y2, radius: 10)
    itemconfigure(@text_id, text: text)
  end
end

canvas = CustomCanvas.new(app)
canvas.pack(fill: 'both', expand: true)


app.mainloop
