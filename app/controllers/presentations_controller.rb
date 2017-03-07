class PresentationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: [:new, :create]
  before_action :set_presentation, only: [:show, :edit, :update, :destroy]

  def index
    @presentations = presentations
  end

  def show
    @participations = Participation.where(presentation_id: @presentation).order(updated_at: :desc)
    @presenters = @participations.where(is_presenter: true)
    @attendees = @participations.where(is_presenter: false)
  end

  def new
    @presentation = Presentation.new
  end

  def create
    @presentation = Presentation.new(presentation_params)
    if @presentation.save
      flash[:success] = success_message(@presentation, :create)
      redirect_to presentations_path
    else
      flash.now[:error] = error_message(@presentation, :create)
      render :new
    end
  end

  def edit
  end

  def update
    if @presentation.update(presentation_params)
      flash[:success] = success_message(@presentation, :update)
      redirect_to @presentation, notice: 'Post was successfully updated.'
    else
      flash.now[:error] = error_message(@presentation, :update)
      render :edit
    end
  end

  def destroy
    if @presentation.destroy
      flash[:success] = success_message(@presentation, :delete)
      redirect_to presentations_url, notice: 'Post was successfully destroyed.'
    else
      flash[:error] = error_message(@presentation, :delete)
      redirect_back fallback_location: presentations_path
    end
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
