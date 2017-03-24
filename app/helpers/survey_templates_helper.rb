#
# SurveyTemplatesHelper
#
module SurveyTemplatesHelper
  #
  # Renders controller action links for index table
  #
  def action_buttons(survey_template)
    edit_link = link_to 'Edit', edit_survey_template_path(survey_template), class: 'btn btn-primary'
    delete_link = link_to 'Delete', survey_template_path(survey_template), class: 'btn btn-danger', method: :delete

    edit_link + delete_link
  end

  #
  # Checks if questions_template is required and returns formatted response for table
  #
  def required_check(questions_template)
    questions_template.response_required ? '✓' : ''
  end
end
