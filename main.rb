require 'bundler'
Bundler.require

require_relative 'canvas_extension'
require_relative 'mindmap'
require_relative 'app.rb'

# Extend the TkCanvas class with our new module methods
class TkCanvas
  include TkCanvasExtensions
end

# Load YAML file and start the application
yaml_file = 'default_map.yml'
data = YAML.load_file(yaml_file)
map = Mindmap.new(data)
map.layout = Layout.new
map.theme = Theme.new

app = App.new
app.load_map(map)
app.run
