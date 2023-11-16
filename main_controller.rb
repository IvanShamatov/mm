require_relative 'main_view'

class Model

end



class MainController
  attr_reader :view, :model

  def initialize
    @view = MainView.new
    @view.controller = self
    @model = Model.new()
  end

  def run
    view.mainloop
  end
end
