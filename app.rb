# Define the main application class
class App
  def initialize
    @root = TkRoot.new { title "Ruby Mind Map" }
    @screen_width = @root.winfo_screenwidth
    @screen_height = @root.winfo_screenheight
    @root.geometry("#{@screen_width}x#{@screen_height}+0+0")
    setup_canvas
  end

  def load_map(map)
    @map = map
    @map.calculate_positions(@screen_width, @screen_height)
    @map.draw(@canvas)
  end

  def setup_canvas
    @canvas = TkCanvas.new(@root, background: 'white') do
      pack(fill: 'both', expand: true)
    end
    @canvas.scrollregion('-3000 -3000 3000 3000')

    # Move the view on mouse drag
    @canvas.bind("Button-3") do |event|
      @canvas.scan_mark(event.x, event.y)
    end

    @canvas.bind('B3-Motion') do |event|
      @canvas.scan_dragto(event.x, event.y)
    end

    # Canvas zoom out
    @canvas.bind('Button-5') do |event|
      @canvas.scale('all', event.x, event.y, 0.9, 0.9)
      # @font.size -= 1
    end

    # Canvas zoom in
    @canvas.bind('Button-4') do |event|
      @canvas.scale('all', event.x, event.y, 1.1, 1.1)
      # @font.size += 1
    end
  end

  def run
    Tk.mainloop
  end
end
