#
# SurveyTemplatesHelper
#
module SurveyTemplatesHelper
  #
  # Renders action links for survey templates
  #
  def action_buttons(edit_path:, delete_path:)
    edit_link = link_to 'Edit', edit_path, class: 'btn btn-primary'
    delete_link = link_to 'Delete', delete_path, class: 'btn btn-danger', method: :delete, data: { confirm: 'Are you sure you want to delete this item?' }

    edit_link + delete_link
  end

  #
  # Checks if questions_template is required and returns formatted response for table
  #
  def required_check(questions_template)
    questions_template.response_required ? '✓' : ''
  end

  #
  # Renders link to create new survey template
  #
  def new_survey_template_link
    link_to 'New Survey Template', new_survey_template_path, class: 'btn btn-success'
  end

  #
  # Renders controller action links for show page
  #
  def survey_template_options
    content_tag :div, class: 'admin-options' do
      edit_link = link_to 'Edit Survey', edit_survey_template_path(@survey_template), class: 'btn btn-primary'
      delete_link = link_to 'Delete Survey', survey_template_path(@survey_template), class: 'btn btn-danger', method: :delete, data: { confirm: 'Are you sure you want to delete this item?' }

      edit_link + delete_link
    end
  end
end
