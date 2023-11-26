Tk.tk_call('source', 'forest-dark.tcl')
Tk::Tile::Style.theme_use "forest-dark"

class App < TkRoot

  def initialize(*args)
    super
    title("Ruby mindmap")
    geometry("#{winfo_screenwidth}x#{winfo_screenheight}+0+0")

    setup_menu
    setup_controls
    @current_content_widget = :map # :outliner
    setup_content_widget
    setup_statusbar
  end

  private

  def setup_menu
    menu = TkMenu.new(self, relief: 'flat')

    # Create a File menu
    file_menu = TkMenu.new(menu, tearoff: 0, relief: 'flat')
    file_menu.add('command', label: 'New', command: {})
    file_menu.add('command', label: 'Open', command: {})
    file_menu.add('command', label: 'Save', command: {})
    file_menu.add('command', label: 'Exit', command: proc { destroy })

    menu.add('cascade', menu: file_menu, label: 'File')
    menu(menu)
  end

  def setup_controls
    @controls_frame = Tk::Tile::Frame.new
    @controls_frame.pack(fill: 'x')

    center_frame = Tk::Tile::Frame.new(@controls_frame, padding: 10).pack(side: 'left')
    Tk::Tile::Button.new(center_frame, text: 'Mindmap', command: {}).pack(side: 'left', padx: 5)
    Tk::Tile::Button.new(center_frame, text: 'Outliner', command: {}).pack(side: 'left', padx: 5)

    right_frame = Tk::Tile::Frame.new(@controls_frame, padding: 10).pack(side: 'right')
    Tk::Tile::Button.new(right_frame, text: 'Zen Mode', command: {}).pack(side: 'left', padx: 5)
    Tk::Tile::Button.new(right_frame, text: 'Pitch Mode', command: {}).pack(side: 'left', padx: 5)
  end

  def setup_content_widget
    @content_frame = Tk::Tile::Frame.new
    @content_frame.pack(fill: 'both', expand: true)

    @canvas = TkCanvas.new(@content_frame, background: 'white')
                      .pack(fill: 'both', expand: true)
    @canvas.scrollregion('-10000 -10000 10000 10000')
  end

  def setup_statusbar
    @statusbar_frame = Tk::Tile::Frame.new(self)
    @statusbar_frame.pack(side: 'bottom', fill: 'x')
    Tk::Tile::Label.new(@statusbar_frame, text: 'Ready!')
                   .pack(side: 'left')
  end
end
