class Layout
  attr_reader :positions

  def initialize(canvas_width, canvas_height)
    @canvas_width = canvas_width
    @canvas_height = canvas_height
    @positions = {}
    @initial_radius = 400
  end

  def calculate_positions(mindmap)
    @mindmap = mindmap
    root_pos = [@canvas_width / 2, @canvas_height / 2]
    place_node(@mindmap.root, root_pos, 0)
    @positions
  end

  private

  def place_node(node, position, depth)
    node.position = position
    @positions[node] = position

    child_nodes = node.children
    if child_nodes.any?
      angle_increment = 360.0 / child_nodes.count
      radius = @initial_radius / (depth + 1)

      child_nodes.each_with_index do |child, index|
        angle = angle_increment * index
        x = position[0] + radius * Math.cos(deg_to_rad(angle))
        y = position[1] + radius * Math.sin(deg_to_rad(angle))
        place_node(child, [x, y], depth + 1)
      end
    end
  end

  def deg_to_rad(degrees)
    degrees * Math::PI / 180
  end
end
