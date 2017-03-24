#
# SurveyTemplatesHelper
#
module SurveyTemplatesHelper
  #
  # Renders controller action links for index table
  #
  def action_buttons(survey_template)
    edit_link = link_to 'Edit', edit_survey_template_path(survey_template), class: 'btn btn-primary'
    delete_link = link_to 'Delete', survey_template_path(survey_template), class: 'btn btn-danger', method: :delete, data: { confirm: 'Are you sure?' }

    edit_link + delete_link
  end

  #
  # Renders controller action links for show page
  #
  def survey_template_options
    content_tag :div, class: 'admin-options' do
      edit_link = link_to 'Edit Survey', edit_survey_template_path(@survey_template), class: 'btn btn-primary'
      delete_link = link_to 'Delete Survey', survey_template_path(@survey_template), class: 'btn btn-danger', method: :delete, data: { confirm: 'Are you sure?' }

      edit_link + delete_link
    end
  end
end
