class Node
  attr_accessor :text, :children, :parent, :depth,
                :xpos, :ypos, :side, :color, :font


  # width_l1 = 33 symbols
  # width_l2 = 44 symbols

  # TODO: make layout attributes: position, side
  # TODO: make theme attributes: color, font, size
  def initialize(text, parent = nil, depth = 0)
    @text = text
    @children = []
    @xpos
    @ypos
    @parent = parent
    @depth = depth
  end

  def add_child(child_node)
    @children << child_node
  end

  def position
    [@xpos, @ypos]
  end
end
