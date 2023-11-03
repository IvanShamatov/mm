# The Layout class
class Layout
  def calculate_positions(map, width:, height:)
    calculate_node_positions(map.root, width/2, height/2, 360, 0)
  end

  private

  def calculate_node_positions(node, center_x, center_y, angle_available, depth)
    node.position = [center_x, center_y]
    return if node.children.empty?
    @node_size = 150

    radius = @node_size * depth
    angle_per_child = angle_available / node.children.size
    node.children.each_with_index do |child, index|
      angle = angle_per_child * index
      x = center_x + radius * Math.cos(to_radians(angle))
      y = center_y + radius * Math.sin(to_radians(angle))
      child.position = [x, y]
      # Increase the angle available and radius for each subsequent depth to avoid overlap
      calculate_node_positions(child, x, y, angle_per_child, depth + 1)
    end
  end

  def to_radians(degrees)
    degrees * Math::PI / 180
  end
end
