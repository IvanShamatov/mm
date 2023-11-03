require 'tk'
require 'yaml'
require 'pry'

require_relative 'canvas_extension'
require_relative 'mindmap'
require_relative 'layout'
require_relative 'app.rb'

# Extend the TkCanvas class with our new module methods
class TkCanvas
  include TkCanvasExtensions
end

# Load YAML file and start the application
yaml_file = 'map.yml'
data = YAML.load_file(yaml_file)
map = Mindmap.new(data)

app = App.new(layout: Layout.new)
app.load_map(map)
app.run

