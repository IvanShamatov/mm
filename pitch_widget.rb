require_relative 'mindmap'

class PitchWidget < TkToplevel
  def initialize(*args)
    super
    attributes(fullscreen: true)
    bind('Escape') { destroy }
    @mindmap = Mindmap.new('Map', YAML.load_file('map.yml'))
    @current_node = @mindmap.root
    @text = TkVariable.new(@current_node.text)
    TkLabel.new(self,
      foreground: 'white',
      font: 'Helvetica 72 bold',
      textvariable: @text
    ).place(relx: 0.5, rely: 0.5, anchor: :center)
    @next_label = TkLabel.new(self,
      text: '>',
      foreground: 'white',
      font: 'Helvetica 72 bold',
      textvariable: @next_arrow
    )
    @prev_label = TkLabel.new(self,
      text: '<',
      foreground: 'white',
      font: 'Helvetica 72 bold',
      textvariable: @prev_arrow
    )
    update

    bind('KeyPress-Up') { prev_child }
    bind('KeyPress-Down') { next_child }
    bind('KeyPress-Left') { to_parent }
    bind('KeyPress-Right') { to_child }
  end

  def update
    @text.value = @current_node.text

    if @current_node.children.any?
      @next_label.place(relx: 0.95, rely: 0.5, anchor: :center)
    else
      @next_label.place_forget
    end

    if @current_node.parent
      @prev_label.place(relx: 0.05, rely: 0.5, anchor: :center)
    else
      @prev_label.place_forget
    end
  end

  # >
  def to_child
    @current_node = @current_node.children.first if @current_node.children.any?
    update
  end

  # <
  def to_parent
    @current_node = @current_node.parent if @current_node.parent
    update
  end

  # V
  def next_child
    if @current_node.parent
      siblings = @current_node.parent.children
      idx = siblings.index(@current_node)
      @current_node = siblings[(idx + 1) % siblings.size]
    end
    update
  end

  # ^
  def prev_child
    if @current_node.parent
      siblings = @current_node.parent.children
      idx = siblings.index(@current_node)
      @current_node = siblings[(idx - 1) % siblings.size]
    end
    update
  end
end
