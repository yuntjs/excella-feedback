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
    params.require(:presentation).permit(:title, :location, :date, :description, :is_published, { user_ids: [] }, :is_presener)
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

  helper_method :toggle_presenter
  def toggle_presenter participation
    if participation.is_presenter
      puts "User #{participation.user_id} is a presenter"
    else
      puts "User #{participation.user_id} is not a presenter"
    end

    participation.is_presenter = !participation.is_presenter

    if participation.is_presenter
      puts "User #{participation.user_id} is now a presenter"
    else
      puts "User #{participation.user_id} is no longer a presenter"
    end
  end

end
