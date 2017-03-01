module PresentationsHelper

  def feedback_header
    current_user.is_admin ? 'Admin' : 'Feedback'
  end

  def display_date(date)
    date.strftime("%a - %-m/%d/%y @ %l:%M %P")
  end

  def display_description(presentation)
    if presentation.description.length > 30
      description = content_tag(:span, presentation.description_short(30))
      view_link = content_tag(:a, '(more)', tabindex: '0', role: 'button',
                    data: {
                      toggle: 'popover',
                      placement: 'bottom',
                      trigger: 'focus',
                      content: presentation.description
                    }
                  )
      description + view_link
    else
      presentation.description
    end
  end

  def feedback_content(presentation, feedback_message)
    if current_user.is_admin
      edit_link = link_to "Edit", edit_presentation_path(presentation), class: 'btn btn-default'
      delete_link = link_to "Delete", presentation_path(presentation), class: "btn btn-default", method: :delete
      survey_link = survey_link_for(presentation)

      edit_link + delete_link + survey_link
    else
      link_to feedback_message
    end
  end

  def survey_link_for(presentation)
    if presentation.surveys.any?
      link_to "See Surveys", presentation_surveys_path(presentation)
    else
      link_to "Create Survey", new_presentation_survey_path(presentation)
    end
  end

end
