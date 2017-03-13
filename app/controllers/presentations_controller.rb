#
# PresentationsController
#
class PresentationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: [:new, :create]
  before_action :set_presentation, only: [:show, :edit, :update, :destroy]

  #
  # Index route
  #
  def index
    @presentations = presentations
  end

  #
  # Show route
  #
  def show
    @participations = Participation.where(presentation_id: @presentation)
                                   .order(updated_at: :desc)
    @presenters = @participations.where(is_presenter: true)
    @attendees = @participations.where(is_presenter: false)
  end

  #
  # New route
  #
  def new
    @presentation = Presentation.new
  end

  #
  # Create route
  #
  def create
    @presentation = Presentation.new(presentation_params)
    if @presentation.save
      flash[:success] = success_message(@presentation, :create)
      # Create default survey
      create_default_presentation_survey
      redirect_to presentations_path
    else
      flash.now[:error] = error_message(@presentation, :create)
      render :new
    end
  end

  #
  # Edit route
  #
  def edit
  end

  #
  # Update route
  #
  def update
    if @presentation.update(presentation_params)
      flash[:success] = success_message(@presentation, :update)
      redirect_to @presentation, notice: 'Post was successfully updated.'
    else
      flash.now[:error] = error_message(@presentation, :update)
      render :edit
    end
  end

  #
  # Destroy route
  #
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

  #
  # Set and sanitize presentation params
  #
  def presentation_params
    params.require(:presentation)
          .permit(:title,
                  :location,
                  :date,
                  :description,
                  :is_published,
                  user_ids: [])
  end

  #
  # Set presentations based on admin/non-admin
  #
  def presentations
    current_user.is_admin ? Presentation.all : current_user.presentations
  end

  #
  # Set presentation to be used in routes
  #
  def set_presentation
    @presentation = Presentation.find(params[:id])
  end

  #
  # Create default survey for presentation
  # Default questions in Question Model
  #
  def create_default_presentation_survey
    survey = @presentation.surveys.create(subject: "Overall Presentation")
    binding.pry
    Question.default_presentation_questions.each do |question|
      Question.create(survey_id: survey.id,
                   prompt: question[:prompt],
                   response_type: question[:response_type])
    end
  end
end
