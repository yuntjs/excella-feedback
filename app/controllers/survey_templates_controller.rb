#
# SurveyTemplatesController
#
class SurveyTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_survey_template, only: [:show, :edit, :update, :destroy]

  #
  # Render Survey Template data
  #
  def index
    @survey_templates = SurveyTemplate.all
  end

  #
  # Show route
  #
  def show
  end

  #
  # New route
  #
  def new
    @survey_template = SurveyTemplate.new
  end

  #
  # Create route
  #
  def create
    @survey_template = SurveyTemplate.new(survey_template_params)
    create_survey_template
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
    update_survey_template
  end

  #
  # Destroy route
  #
  def destroy
    destroy_survey_template
  end

  private

  #
  # Set survey_template to be used in routes
  #
  def set_survey_template
    @survey_template = SurveyTemplate.find(params[:id])
  end

  #
  # Set and sanitize survey params
  #
  def survey_template_params
    params.require(:survey_template).permit(:title, :name)
  end

  #
  # Logic helper for create action
  # Extrapolated into new method to appease Rubocop
  #
  def create_survey_template
    if @survey_template.save
      flash[:success] = success_message(@survey_template, :create)
      redirect_to survey_template_path(@survey_template)
    else
      flash.now[:error] = error_message(@survey_template, :create)
      render :new
    end
  end

  #
  # Logic helper for update action
  # Extrapolated into new method to appease Rubocop
  #
  def update_survey_template
    if @survey_template.update(survey_template_params)
      flash[:success] = success_message(@survey_template, :update)
      redirect_to @survey_template, notice: 'Survey Template was successfully updated.'
    else
      flash.now[:error] = error_message(@survey_template, :update)
      render :edit
    end
  end

  #
  # Logic helper for destroy action
  # Extrapolated into new method to appease Rubocop
  #
  def destroy_survey_template
    if @survey_template.destroy
      flash[:success] = success_message(@survey_template, :delete)
      redirect_to survey_templates_url, notice: 'Survey Template was successfully destroyed.'
    else
      flash[:error] = error_message(@survey_template, :delete)
      redirect_back fallback_location: survey_templates_path
    end
  end
end
