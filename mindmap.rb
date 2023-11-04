class Mindmap
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

  attr_reader :root

  def initialize(hash)
    @root = create_node(hash)
  end

  private

  def create_node(hash, parent: nil, depth: 0)
    node = Node.new(hash["title"], parent, depth)
    if hash["children"]
      hash["children"].each do |child_hash|
        child_node = create_node(child_hash, parent: node, depth: depth + 1)
        node.add_child(child_node)
      end
    end
    node
  end
end
