class PresentationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: [:new, :create]
  before_action :set_presentation, only: [:show, :edit, :update, :destroy]

  def index
    @presentations = presentations
    # if @presentations.none?
    #   redirect_to nopresentations_path
    # end
  end

  def show
    @presentation = Presentation.find(params[:id])
    @participations = Participation.where(presentation_id: @presentation).order(updated_at: :desc)
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

  def update
    if @presentation.update(presentation_params)
      redirect_to @presentation, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @presentation.destroy
      redirect_to presentations_url, notice: 'Post was successfully destroyed.'
  end



private

  def presentation_params
    params.require(:presentation).permit(:title, :location, :date, :description, :is_published, { user_ids: [] })
  end

  def presentations
    if current_user.is_admin
      Presentation.all
    else
      current_user.presentations
    end
  end

  def set_presentation
    @presentation = Presentation.find(params[:id])
  end

  def no_presentations
  end


end
