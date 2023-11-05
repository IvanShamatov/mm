class Theme
  attr_accessor :map

  def initialize
    @font = TkFont.new(family: 'Helvetica', size: 18)
  end

  def draw(canvas)
    exit(1) unless map

    @canvas = canvas
    draw_lines(map.root)
    draw_nodes(map.root)
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

    radius = 15
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
end
