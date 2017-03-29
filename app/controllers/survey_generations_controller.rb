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
    presentation = Presentation.find_by(id: params[:presentation_id])
    survey_template = SurveyTemplate.find_by(id: params[:survey_template_id])

    survey = Survey.create_from_template(presentation: presentation, survey_template: survey_template)
    questions = Question.create_from_templates(survey, survey_template.question_templates)

    if survey.save && questions
      flash[:success] = 'A new survey has been added to the presentation.'
    else
      flash[:error] = 'A new survey could not be created from the selected template.'
    end

    redirect_to presentation_surveys(presentation_id: params[:presentation_id])
  end
end
