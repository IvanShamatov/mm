require_relative 'mindmap'
# Extend the TkCanvas class with our new module methods
require_relative 'canvas_extension'
class TkCanvas
  include TkCanvasExtensions
end

class App
  def initialize
    @root = TkRoot.new { title "Ruby Mind Map" }
    Tk.tk_call('source', 'forest-dark.tcl')
    Tk::Tile::Style.theme_use "forest-dark"
    @screen_width = @root.winfo_screenwidth
    @screen_height = @root.winfo_screenheight
    @root.geometry("#{@screen_width}x#{@screen_height}+0+0")
    setup_menu
    setup_views
    setup_statusbar
    load_map('default_map.yml')
  end

  def setup_views
    content = Tk::Tile::Frame.new(@root)

    setup_editor(content)
    setup_canvas(content)
    content.pack(fill: 'both', expand: true)
  end

  def setup_menu
    # Create a menu
    menu = TkMenu.new(@root, relief: 'flat')

    # Create a File menu
    file_menu = TkMenu.new(menu, tearoff: 0)
    menu.add('cascade', menu: file_menu, label: 'File')

    # Add menu items to the File menu
    # file_menu.add('command', label: 'New', command: proc { puts 'New selected' })
    file_menu.add('command', label: 'Open', command: proc { load_map })
    file_menu.add('command', label: 'Exit', command: proc { @root.destroy })

    @root.menu(menu)
  end

  def setup_editor(content)
    @editor_frame =
      Tk::Tile::Frame.new(content, width: @screen_width / 3)
        .pack(side: :left, fill: 'both')

    @editor = TkText.new(@editor_frame, font: TkFont.new(family: 'Helvetica', size: 14), relief: 'flat', border: 1)
                    .pack(side: :left, fill: 'both')

    @redraw = Tk::Tile::Button.new(@editor_frame, text: 'Redraw', command: proc{ redraw })
                    .pack(side: :left)
  end

  def redraw(data = nil, filename= 'filename.yml')
    data = YAML.load(@editor.get('1.0', 'end')) if data.nil?
    @canvas.delete('all')
    @map = Mindmap.new(File.basename(filename, '.yml'), data)
    @loaded_maps << @map
    index = @loaded_maps.size - 1
    Tk::Tile::RadioButton
      .new(@status_frame, text: @map.title, variable: @current_map_id, value: index)
      .pack(side: :left).command { switch_maps }

    @map.layout = Layout.new
    @map.theme = Theme.new
    @map.calculate_positions(@screen_width * 2 / 3, @screen_height)
    @map.draw(@canvas)
  end

  def setup_statusbar
    @current_map_id = TkVariable.new { 0 }
    @loaded_maps = []
    # Create a frame at the bottom for the status bar
    status_frame = Tk::Tile::Frame.new(@root)
    status_frame.pack(side: 'bottom', fill: 'x')
  end

  def switch_maps
    @canvas.delete('all')
    @map = @loaded_maps[@current_map_id]
    @map.layout = Layout.new
    @map.theme = Theme.new
    @map.calculate_positions(@screen_width, @screen_height)
    @map.draw(@canvas)
  end

  def load_map(filename = Tk::getOpenFile)
    data = YAML.load_file(filename)
    @text = File.read(filename)
    @editor.insert(1.0, @text)
    redraw(data, filename)
  end

  def setup_canvas(content)
    @canvas = TkCanvas.new(content, background: 'white')
                      .pack(fill: 'both', expand: true)
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
