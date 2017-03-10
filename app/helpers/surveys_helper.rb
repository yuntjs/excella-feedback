module SurveysHelper
  # Renders options/links for Presentation show page
  def survey_admin_options(user, presentation)
    if user.is_admin
      content_tag :div, class: "admin-options" do
        new_survey_link = link_to 'Create New Survey', new_presentation_survey_path(presentation), class: "btn btn-primary"
        new_survey_link
      end
    end
  end
end
