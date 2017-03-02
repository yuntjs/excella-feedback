class PresentationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: [:new, :create]
  before_action :set_presentation, only: [:show, :edit, :update, :destroy]

  def index
    @presentations = presentations
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
      flash[:notice] = "Presentation has been successfully created."
      redirect_to presentations_path
    else
      flash.now[:error] = "We ran into some errors while trying to create this presentation."
      render :new
    end
  end

  def edit
  end

  def update
    if @presentation.update(presentation_params)
      flash[:notice] = "Presentation has been successfully update."
      redirect_to @presentation, notice: 'Post was successfully updated.'
    else
      flash.now[:error] = "We ran into some errors while trying to update this presentation."
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
    current_user.is_admin ? Presentation.all : current_user.presentations
  end

  def set_presentation
    @presentation = Presentation.find(params[:id])
  end

end
