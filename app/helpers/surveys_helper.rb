#
# SurveysHelper
#
module SurveysHelper
  #
  # Renders options/links for Presentation show page
  #
  def new_survey_action_button(user, presentation)
    participation = Participation.where(user_id: user.id, presentation_id: presentation.id).first

    return unless user.is_admin || participation.is_presenter
    content_tag :div, class: 'admin-options' do
      link_to 'Create New Survey', new_presentation_survey_path(presentation), class: 'btn btn-primary'
    end
  end

  #
  # Renders controller action links for index page
  #
  def survey_option_buttons(survey)
    content_tag :div, class: 'admin-options' do
      edit_button = link_to 'Edit Survey',
                          edit_presentation_survey_path(@presentation, survey),
                          class: "btn btn-primary #{disable_check(survey, current_user)}"
      delete_button = link_to 'Delete Survey',
                            presentation_survey_path(@presentation, survey),
                            class: "btn btn-danger #{disable_check(survey, current_user)}",
                            method: :delete,
                            data: { confirm: 'Are you sure you want to delete this item?' }

      edit_button + delete_button
    end
  end

  #
  # Returns css class to disable links if survey is for a different presenter
  #
  def disable_check(survey, user)
    return if survey.presenter_id.nil? || user.is_admin || survey.presenter_id == user.id
    'disabled'
  end
end
