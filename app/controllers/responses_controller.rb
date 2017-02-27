class ResponsesController < ApplicationController
  def new
    @presentation = Presentation.find(params[:presentation_id])
  end

  def create

  end
end
