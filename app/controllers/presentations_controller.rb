
class PresentationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: [:new, :create]

  def index
    @presentations = presentations
  end

  def new
    @presentation = Presentation.new
  end

  def create
    @presentation = Presentation.new(presentation_params)
    if @presentation.save
      redirect_to presentations_path
    elsif
      render :new
    end
  end

  def edit

  end

private

  def presentation_params
    params.require(:presentation).permit(:title, :location, :date, :description, :is_published)
  end

  def presentations
    if current_user.is_admin
      Presentation.all
    else
      current_user.presentations
    end
 end

end
