# Define the main application class
class App
  def initialize
    @root = TkRoot.new { title "Ruby Mind Map" }
    @screen_width = @root.winfo_screenwidth
    @screen_height = @root.winfo_screenheight
    @root.geometry("#{@screen_width}x#{@screen_height}+0+0")

    setup_menu
    setup_canvas
    setup_statusbar
  end

  def setup_menu
    # Create a menu
    menu = TkMenu.new(@root)

    # Create a File menu
    file_menu = TkMenu.new(menu, tearoff: 0)
    menu.add('cascade', menu: file_menu, label: 'File')

    # Add menu items to the File menu
    file_menu.add('command', label: 'New', command: proc { puts 'New selected' })
    file_menu.add('command', label: 'Open', command: proc { puts 'Open selected' })
    file_menu.add('command', label: 'Exit', command: proc { @root.destroy })

    @root.menu(menu)
  end

  def setup_statusbar
    # Create a frame at the bottom for the status bar
    status_frame = TkFrame.new(@root)
    status_frame.pack(side: 'bottom', fill: 'x')

    # Create a label widget to display status messages
    @status_label = TkLabel.new(status_frame, text: "Ready", relief: 'sunken', anchor: 'w')
    @status_label.pack(fill: 'x')
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
