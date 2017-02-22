class PresentationsController < ApplicationController
  def index
    @presentations = Presentation.all
  end
end
