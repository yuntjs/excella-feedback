#
# PresentationsHelper
#
module PresentationsHelper
  #
  # Returns Presentation object based on role of user
  #
  def presentations_as(role, user)
    case role
    when :presenter
      is_presenter = true
    when :attendee
      is_presenter = false
    else
      return Presentation.none
    end

    Presentation.joins(:users, :participations).where(
      users: { id: user.id },
      participations: { is_presenter: is_presenter }
    ).distinct
  end

  #
  # Renders partial of Presentation table for admin users
  #
  def admin_table(user)
    if user.is_admin
      render partial: 'presentations/presentation_table', locals: { title: 'As Admin', presentations: @presentations, feedback_message: nil, panel_color: 'panel-warning' }
    end
  end

  #
  # Renders partial of Presentation table for non-admin users
  # Handles difference between presenter and attendee users
  #
  def general_user_table(user:, role:, title:, feedback_message:)
    panel_color = role == :presenter ? 'panel-info' : 'panel-default'
    if presentations_as(role, user).any?
      render partial: 'presentations/presentation_table', locals: { title: title, presentations: presentations_as(role, user), feedback_message: feedback_message, panel_color: panel_color }
    end
  end

  #
  # Sets value for header of feedback (right-most) column in Presentation index tables
  #
  def feedback_header(user)
    user.is_admin ? 'Admin' : 'Feedback'
  end

  #
  # Sets variables for Presentation description popover
  #
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

  #
  # Sets variables for Presentation feedback options/links
  # Handles differences between admin, presenter, and/or attendee users
  #
  def feedback_content(user:, presentation:, feedback_message:)
    if user.is_admin
      survey_link = survey_link_for(presentation)
      edit_link = link_to 'Edit', edit_presentation_path(presentation), class: 'btn btn-primary'
      delete_link = link_to 'Delete', presentation_path(presentation), class: 'btn btn-danger', method: :delete

      survey_link + edit_link + delete_link
    else
      feedback_button(user, presentation)
    end
  end

  #
  # Renders provide feedback button
  # Handles if user is presenter or attendee
  #
  def feedback_button(user, presentation)
    if (presentation.date - Time.now > 0)
      link_to "Available after Presentation", '#', class: 'btn btn-default disabled'
    elsif (user.is_presenter?(presentation) || user.is_admin)
      link_to 'See Feedback', presentation_responses_path(presentation), class: 'btn btn-success'
    else
      provide_feedback_button(user, presentation)
    end
  end

  #
  # Display link based on whether presentation surveys have been completed
  #
  def provide_feedback_button(user, presentation)
    participation = Participation.where(user_id: user.id, presentation_id: presentation.id).first

    if participation.feedback_provided
      link_to 'Feedback Submitted', '#', class: 'btn btn-success disabled'
    else
      link_to 'Provide Feedback', new_presentation_response_path(presentation), class: 'btn btn-warning'
    end
  end

  #
  # Renders proper link to survey and results based on user type (presenter or attendee)
  # TODO Handle case where attendee has already completed survey
  #
  def survey_link_for(presentation)
    if presentation.surveys.any?
      link_to 'See Surveys', presentation_surveys_path(presentation), class: 'btn btn-default'
    else
      link_to 'Create Survey', new_presentation_survey_path(presentation), class: 'btn btn-default'
    end
  end

  #
  # Renders options/links for Presentation show page
  #
  def presentation_admin_options(user, presentation)
    if user.is_admin
      content_tag :div, class: 'admin-options' do
        edit_details_link = link_to 'Edit Details', edit_presentation_path(presentation), class: 'btn btn-primary'
        edit_participants_link = content_tag :button, 'Edit Participants', class: 'btn btn-primary',
          data: {
            toggle: 'modal',
            target: '.bs-example-modal-sm'
          }
        view_surveys_link = link_to 'View Surveys', presentation_surveys_path(presentation), class: 'btn btn-primary'
        delete_link = link_to 'Delete', presentation_path(presentation), class: 'btn btn-danger', method: :delete, data: { confirm: 'Are you sure?' }

        edit_details_link + edit_participants_link + view_surveys_link + delete_link
      end
    end
  end

  #
  # Renders partial of Participation table
  # Handles if user is presenter or attendee
  #
  def participation_table(user:, role:, participations:)
    panel_color = role == :presenter ? 'panel-info' : 'panel-default'
    render partial: 'presentations/participation_table', locals: {
      title: set_participation_title(role, participations),
      participations: participations,
      panel_color: panel_color,
      role: role
    }
  end

  #
  # Renders link to edit Participation based on user type (presenter or attendee)
  #
  def toggle_participation_link(participation)
    if participation.is_presenter
      link_to 'Change to Attendee', presentation_participation_path(@presentation, participation, participation: { is_presenter: false }), method: :put
    else
      link_to 'Change to Presenter', presentation_participation_path(@presentation, participation, participation: { is_presenter: true }), method: :put
    end
  end

  #
  # Sets title and handles plurality for Participations (presenter, attendee)
  #
  def set_participation_title(role, participants)
    participants == 1 ? role.to_s : role.to_s.pluralize
  end
end
