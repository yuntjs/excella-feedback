#
# SurveyTemplatesController
#
class SurveyTemplatesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_survey_template, only: [:show]

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
end
