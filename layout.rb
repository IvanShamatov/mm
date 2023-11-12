require 'pry'

class Layout
  LayoutException = Class.new(StandardError)

  attr_reader :positions
  attr_accessor :map

  def initialize
    @positions = {}
    @l1_xshift = 150
    @l2_xshift = 150
    @l1_yshift = 100
    @l2_yshift = 50
  end

  def calculate_positions(width, height)
    raise LayoutException, 'Map not loaded' unless map

    directionize(map.root)
    place_node(map.root, width / 2, height / 2)
  end

  private

  def directionize(node, direction = nil)
    if direction.nil? # root
      left_branch_size = node.children.size / 2

      node.children[0..left_branch_size].each do |child|
        directionize(child, :left)
      end

      node.children[left_branch_size..].each do |child|
        directionize(child, :right)
        child.side = :right
      end
    else
      node.side = direction
      node.children.each { directionize(_1, direction) }
    end
  end

  def place_node(node, x, y)
    node.xpos, node.ypos = x, y
    @positions[node] = [x, y]

    node.children.group_by { _1.side }.each do |side, nodes|
      start_y = y - ((nodes.count - 1) * yshift(node)) / 2

      nodes.each_with_index do |child, index|
        new_y = start_y + index * yshift(node)
        new_x = if side == :left
                  x - xshift(node)
                else
                  x + xshift(node)
                end
        place_node(child, new_x, new_y)
      end
    end
  end

  def yshift(node)
    node.depth >= 1 ? @l2_yshift : @l1_yshift
  end

  def xshift(node)
    node.depth >= 1 ? @l2_xshift : @l1_xshift
  end
end
