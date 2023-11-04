# Define the main application class
class App
  def initialize(layout:)
    @root = TkRoot.new { title "Ruby Mind Map" }
    @screen_width = @root.winfo_screenwidth
    @screen_height = @root.winfo_screenheight
    @root.geometry("#{@screen_width}x#{@screen_height}+0+0")

    @font = TkFont.new(family: 'Helvetica', size: 14)

    @canvas = TkCanvas.new(@root) do
      pack(fill: 'both', expand: true)
    end
    @layout = layout.new(@screen_width, @screen_height)
  end

  def load_map(map)
    @map = map
    @layout.calculate_positions(map)
    draw
  end

  def draw
    draw_lines(@map.root)
    draw_nodes(@map.root)
  end

  def draw_lines(node)
    x, y = node.position
    node.children.each do |child|
      chx, chy = child.position
      @canvas.create_line(x, y, chx, chy)

      draw_lines(child) if child.children
    end
  end

  def draw_nodes(node, parent = nil)
    # Draw this node
    draw_node(node, parent)

    # Recursively draw children nodes
    node.children.each do |child|
      draw_nodes(child, node)
    end
  end

  def draw_node(node, parent)
    title = node.title
    x, y  = node.position
    parent_position = parent&.position

    radius = 10
    rect_width = @font.measure(title) + radius * 2
    rect_height = @font.metrics('linespace') + radius * 2

    # Use the extended create_rectangle method with rounded corners
    @canvas.create_rectangle(x - rect_width / 2, y - rect_height / 2,
                             x + rect_width / 2, y + rect_height / 2,
                             radius: radius, fill: 'white', outline: 'black')

    # Draw the title
    down = @font.metrics('descent') / 2
    @canvas.create_text(x, y + down, text: title, font: @font)
  end

  def run
    Tk.mainloop
  end
end
