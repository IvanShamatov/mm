class Mindmap
  class Node
    attr_accessor :title, :children, :position

    def initialize(title)
      @title = title
      @children = []
      @position = []
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

  def create_node(hash)
    node = Node.new(hash["title"])
    if hash["children"]
      hash["children"].each do |child_hash|
        child_node = create_node(child_hash)
        node.add_child(child_node)
      end
    end
    node
  end
end
