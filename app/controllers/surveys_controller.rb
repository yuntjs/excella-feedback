#
# SurveysController
#
class SurveysController < ApplicationController
  before_action :authenticate_admin_or_presenter, except: :show
  before_action :set_presentation

  #
  # Index route
  #
  def index
  end

  #
  # New route
  #
  def new
    @survey = @presentation.surveys.new
  end

  #
  # Create route
  #
  def create
    @survey = @presentation.surveys.new(survey_params)
    save_survey
  end

  #
  # Show route
  #
  def show
    @survey = Survey.find(params[:id])
  end

  #
  # Edit route
  #
  def edit
    @survey = Survey.find(params[:id])
  end

  #
  # Update route
  #
  def update
    @survey = Survey.find(params[:id])
    update_survey
  end

  #
  # Destroy route
  #
  def destroy
    @survey = Survey.find(params[:id])
    if @survey.destroy
      flash[:success] = success_message(@survey, :delete)
      redirect_to presentation_surveys_path
    else
      flash[:error] = error_message(@question, :delete)
      redirect_back fallback_location: presentation_survey_path(@presentation.id, @survey.id)
    end
  end

  private

  #
  # Set and sanitize survey params
  #
  def survey_params
    params.require(:survey).permit(:presentation_id, :title, :position)
  end

  #
  # Set presentation to be used in routes
  #
  def set_presentation
    @presentation = Presentation.find(params[:presentation_id])
  end

  #
  # Save helper for create action
  # Extrapolated into new method to appease Rubocop
  #
  def save_survey
    if @survey.save
      flash[:success] = success_message(@survey, :create)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    else
      flash.now[:error] = error_message(@survey, :create)
      render :new
    end
  end

  #
  # Update helper for update action
  # Extrapolated into new method to appease Rubocop
  #
  def update_survey
    if @survey.update(survey_params)
      flash[:success] = success_message(@survey, :update)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    else
      flash.now[:error] = error_message(@survey, :create)
      render :edit
    end
  end
end
