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

    survey = Survey.build_from_template(presentation: presentation, survey_template: survey_template)
    questions = Question.build_from_templates(survey: survey, question_templates: survey_template.question_templates)

    if survey.valid? && Question.valid_collection?(questions)
      survey.save
      Question.save_collection(questions)

      flash[:success] = 'A new survey has been added to the presentation.'
    else
      flash[:error] = 'The survey could not be added to the presentation.'
    end

    redirect_to presentation_surveys_path(presentation_id: params[:presentation_id])
  end
end
