require 'forwardable'

require_relative 'layout'
require_relative 'theme'
require_relative 'node'

class Mindmap
  extend Forwardable

  attr_reader :root, :list

  def initialize(hash)
    @list = []
    @root = create_node(hash)
    calculate_weights
  end

  def layout=(layout)
    layout.map = self
    @layout = layout
  end

  def theme=(theme)
    theme.map = self
    @theme = theme
  end

  def_delegator :@layout, :calculate_positions
  def_delegator :@theme, :draw

  private

  def create_node(hash, parent: nil, depth: 0)
    node = Node.new("#{hash["text"]}", parent, depth)
    @list << node
    if hash["children"]
      hash["children"].each do |child_hash|
        child_node = create_node(child_hash, parent: node, depth: depth + 1)
        node.add_child(child_node)
      end
    end
    node
  end

  def calculate_weights
    max_depth = @list.max_by(&:depth).depth
    (max_depth - 1).downto(0) do |level|
      @list.select { _1.depth == level }.each do |node|
        node.weight = if node.children.empty?
                        1
                      else
                        node.children.sum(&:weight)
                      end
      end
    end
  end

end
