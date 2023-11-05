class Theme
  attr_accessor :map

  COLORS = [:red, :orange, :yellow, :green, :blue, :violet]

  L1_COLORS = {
    red: '#F9423A',
    orange: '#F6A04D',
    yellow: '#F3D321',
    green: '#00BC7B',
    blue: '#486AFF',
    violet: '#4D49BE'
  }

  L2_COLORS = {
    red: '#fca09c',
    orange: '#facfa6',
    yellow: '#f9e990',
    green: '#fcf4c7',
    blue: '#a3b4ff',
    violet: '#a6a4de'
  }

  L1_TEXT_COLORS = {
    red: 'white',
    orange: 'black',
    yellow: 'black',
    green: 'black',
    blue: 'white',
    violet: 'white'
  }

  L2_TEXT_COLORS = {
    red: '#620703',
    orange: '#613204',
    yellow: '#605205',
    green: '#006642',
    blue: '#001266',
    violet: '#1C1A4B'
  }
  def initialize
    @current_color = -1
  end

  def draw(canvas)
    exit(1) unless map

    setup_nodes_colors(map.root)
    setup_nodes_fonts(map.root)

    @canvas = canvas
    draw_lines(map.root)
    draw_nodes(map.root)
  end

  def draw_lines(node)
    x, y = node.position
    node.children.each do |child|
      chx, chy = child.position
      @canvas.create_line(x, y, chx, chy, fill: L1_COLORS[child.color], width: 3)

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

    radius = node_radius(node)

    rect_width = node.font.measure(title) + radius * 2
    rect_height = node.font.metrics('linespace') + radius * 2

    @canvas.create_rectangle(x - rect_width / 2, y - rect_height / 2,
      x + rect_width / 2, y + rect_height / 2,
      radius: radius, fill: background_color(node))

    # Draw the title
    down = node.font.metrics('descent') / 2
    @canvas.create_text(x, y + down, text: title, font: node.font, fill: text_color(node))
  end

  def setup_nodes_colors(node)
    node.color =
      case node.depth
      when 0
        'black'
      when 1
        @current_color +=1
        COLORS[@current_color]
      else
        node.parent.color
      end

    node.children.each { setup_nodes_colors(_1) }
  end

  def setup_nodes_fonts(node)
    node.font = TkFont.new(family: 'Helvetica', size: 14)
      # case node.depth
      # when 0
      #   TkFont.new(family: 'Helvetica', size: 24)
      # when 1
      #   TkFont.new(family: 'Helvetica', size: 20)
      # when 2..
      #   TkFont.new(family: 'Helvetica', size: 14)
      # end

    node.children.each { setup_nodes_fonts(_1) }
  end

  def background_color(node)
    case node.depth
    when 0
      'black'
    when 1
      L1_COLORS[node.color]
    else
      L2_COLORS[node.color]
    end
  end

  def text_color(node)
    case node.depth
    when 0
      'white'
    when 1
      L1_TEXT_COLORS[node.color]
    else
      L2_TEXT_COLORS[node.color]
    end
  end

  def node_radius(node)
    case node.depth
    when 0
      15
    when 1
      10
    else
      8
    end
  end
end
