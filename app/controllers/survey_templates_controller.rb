#
# SurveyTemplatesController
#
class SurveyTemplatesController < ApplicationController
  before_action :authenticate_admin
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
    @survey_template = SurveyTemplate.find(params[:id])
  end
end
