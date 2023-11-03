module TkCanvasExtensions
  def create_oval(x1, y1, x2, y2, options = {})
    TkcOval.new(self, x1, y1, x2, y2, options)
  end

  def create_rectangle(x1, y1, x2, y2, options = {})
    if options[:radius] && options[:radius] > 0
      create_rounded_rectangle(x1, y1, x2, y2, options[:radius], options.except(:radius))
    else
      TkcRectangle.new(self, x1, y1, x2, y2, options)
    end
  end

  def create_text(x, y, options = {})
    TkcText.new(self, x, y, options)
  end

  def create_line(x1, y1, x2, y2, options = {})
    TkcLine.new(self, x1, y1, x2, y2, options)
  end

  private

  def create_rounded_rectangle(x1, y1, x2, y2, radius, options = {})
    # Adjust coordinates for the radius
    inner_x1, inner_y1, inner_x2, inner_y2 = x1 + radius, y1 + radius, x2 - radius, y2 - radius

    # Create the straight edges of the rectangle
    TkcLine.new(self, inner_x1, y1, inner_x2, y1, options) # Top edge
    TkcLine.new(self, x2, inner_y1, x2, inner_y2, options) # Right edge
    TkcLine.new(self, inner_x1, y2, inner_x2, y2, options) # Bottom edge
    TkcLine.new(self, x1, inner_y1, x1, inner_y2, options) # Left edge

    # Create the rounded corners using arcs
    TkcArc.new(self, x1, y1, x1 + 2 * radius, y1 + 2 * radius, start: 90, extent: 90, style: 'arc', **options) # Top-left corner
    TkcArc.new(self, x2 - 2 * radius, y1, x2, y1 + 2 * radius, start: 0, extent: 90, style: 'arc', **options) # Top-right corner
    TkcArc.new(self, x2 - 2 * radius, y2 - 2 * radius, x2, y2, start: 270, extent: 90, style: 'arc', **options) # Bottom-right corner
    TkcArc.new(self, x1, y2 - 2 * radius, x1 + 2 * radius, y2, start: 180, extent: 90, style: 'arc', **options) # Bottom-left corner

    # Create the inner rectangle to fill the color if the fill option is provided
    if options[:fill]
      TkcRectangle.new(self, inner_x1, inner_y1, inner_x2, inner_y2, fill: options[:fill], outline: options[:fill])
    end
  end
end
