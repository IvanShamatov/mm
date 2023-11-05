class Node
  attr_accessor :title, :children, :position, :parent, :depth

  def initialize(title, parent = nil, depth = 0)
    @title = title
    @children = []
    @position = []
    @parent = parent
    @depth = depth
  end

  def add_child(child_node)
    @children << child_node
  end
end
