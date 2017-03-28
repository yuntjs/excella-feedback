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
end
