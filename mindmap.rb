require 'forwardable'

require_relative 'layout'
require_relative 'theme'
require_relative 'node'

class Mindmap
  extend Forwardable

  attr_reader :root

  def initialize(hash)
    @root = create_node(hash)
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
    node = Node.new("#{hash["title"]} - depth: #{depth}", parent, depth)
    if hash["children"]
      hash["children"].each do |child_hash|
        child_node = create_node(child_hash, parent: node, depth: depth + 1)
        node.add_child(child_node)
      end
    end
    node
  end
end
