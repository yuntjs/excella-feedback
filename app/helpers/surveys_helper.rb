#
# SurveysHelper
#
module SurveysHelper
  #
  # Renders options/links for Presentation show page
  #
  def survey_admin_options(user, presentation)
    participation = Participation.where(user_id: user.id, presentation_id: presentation.id).first

    return unless user.is_admin || participation.is_presenter
    content_tag :div, class: 'admin-options' do
      new_survey_link = link_to 'Create New Survey', new_presentation_survey_path(presentation), class: 'btn btn-primary'
      new_survey_link
    end
  end

  #
  # Renders controller action links for show page
  #
  def survey_options
    content_tag :div, class: 'admin-options' do
      edit_link = link_to 'Edit Survey', edit_presentation_survey_path(@presentation, @survey), class: 'btn btn-primary'
      delete_link = link_to 'Delete Survey', presentation_survey_path(@presentation, @survey), class: 'btn btn-danger', method: :delete, data: { confirm: 'Are you sure you want to delete this item?' }

      edit_link + delete_link
    end
  end

  #
  # Renders controller action links for index page
  #
  def survey_index_options(survey)
    content_tag :div, class: 'admin-options' do
      edit_link = link_to 'Edit Survey', edit_presentation_survey_path(@presentation, survey), class: "btn btn-primary #{disable_check(survey, current_user)}"
      delete_link = link_to 'Delete Survey', presentation_survey_path(@presentation, survey), class: "btn btn-danger #{disable_check(survey, current_user)}", method: :delete, data: { confirm: 'Are you sure you want to delete this item?' }

      edit_link + delete_link
    end
  end

  #
  # Returns css class to disable links if survey is for a different presenter
  #
  def disable_check(survey, user)
    return if survey.presenter_id.nil? || user.is_admin || survey.presenter_id == user.id
    'disabled'
  end

  #
  # Return a confirmation message data object if a survey template title matches a survey
  #
  def duplicate_confirm(survey_template, surveys)
    survey_titles = surveys.pluck(:title).map(&:downcase)

    if survey_titles.include?(survey_template.title.downcase)
      { confirm: 'Are you sure you want to add a duplicate survey?' }
    end
  end
end
