#
# SurveyGenerationsController
#
class SurveyGenerationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  #
  # Generate survey for a presentation using a survey template
  #
  def create
    set_instance_variables
    generate_survey_and_questions

    flash[:success] = 'A new survey has been added to the presentation.'
    redirect_to presentation_surveys_path(@presentation)
  end

  private

  #
  # Set instance variables
  #
  def set_instance_variables
    @presentation = Presentation.find_by(id: params[:presentation_id])
    @survey_template = SurveyTemplate.find_by(id: params[:survey_template_id])
  end

  #
  # Generate unsaved survey & its questions from templates
  #
  def generate_survey_and_questions
    @survey = Survey.create_from_template(presentation: @presentation, survey_template: @survey_template)
    @questions = Question.create_from_templates(survey: @survey, question_templates: @survey_template.question_templates)
  end
end
