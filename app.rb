# Define the main application class
class App
  def initialize(layout: Layout.new)
    @root = TkRoot.new { title "Ruby Mind Map" }
    @screen_width = @root.winfo_screenwidth
    @screen_height = @root.winfo_screenheight
    @root.geometry("#{@screen_width}x#{@screen_height}+0+0")

    @canvas = TkCanvas.new(@root) do
      pack(fill: 'both', expand: true)
    end
    @layout = layout
  end

  def load_map(map)
    @map = map
    @layout.calculate_positions(map, width: @screen_width, height: @screen_height)
    draw
  end

  def draw
    draw_nodes(@map.root)
  end

  def draw_nodes(node, parent_coords = nil)
    # Draw this node
    draw_node(node.title, node.position, parent_coords)

    # Recursively draw children nodes
    node.children.each do |child|
      draw_nodes(child, node.position)
    end
  end

  def draw_node(title, position, parent_position = nil)
    x, y = position
    radius = 10
    rect_width = 60
    rect_height = 30

    # Use the extended create_rectangle method with rounded corners
    @canvas.create_rectangle(x - rect_width / 2, y - rect_height / 2,
                             x + rect_width / 2, y + rect_height / 2,
                             radius: radius)#, fill: 'white', outline: 'black')

    # Draw the title
    @canvas.create_text(x, y, text: title)

    # Draw a line to the parent node if it exists
    if parent_position
      parent_x, parent_y = parent_position
      @canvas.create_line(parent_x, parent_y, x, y)
    end
  end

  def run
    Tk.mainloop
  end
end
