module SurveysHelper
  # Renders options/links for Presentation show page
  def survey_admin_options(user, presentation)
    if user.is_admin
      content_tag :div, class: "admin-options" do
        link_to 'Create New Survey', new_presentation_survey_path(presentation), class: "btn btn-primary"
      end
    end
  end
end
