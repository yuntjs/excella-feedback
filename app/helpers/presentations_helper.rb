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

    Presentation.joins(:users, :participations).where(users: { id: user.id }, participations: { is_presenter: is_presenter }).distinct
  end

  #
  # Renders partial of Presentation table for admin users
  #
  def admin_table(user)
    return unless user.is_admin
    render partial: 'presentations/presentation_table', locals: { title: 'As Admin', presentations: @presentations, feedback_message: nil, panel_color: 'panel-warning' }
  end

  #
  # Renders partial of Presentation table for non-admin users
  # Handles difference between presenter and attendee users
  #
  def general_user_table(user:, role:, title:, feedback_message:)
    return unless presentations_as(role, user).any?
    panel_color = role == :presenter ? 'panel-info' : 'panel-default'
    render partial: 'presentations/presentation_table', locals: { title: title, presentations: presentations_as(role, user), feedback_message: feedback_message, panel_color: panel_color }
  end

  #
  # Sets value for header of feedback (right-most) column in Presentation index tables
  #
  def feedback_header(title)
    return 'Feedback' if title == 'As Presenter' || title == 'As Attendee'
    'Admin'
  end

  #
  # Sets variables for Presentation description popover
  #
  def display_description(presentation)
    if presentation.description.length > 30
      description = content_tag(:span, presentation.description_short(30))
      view_link = content_tag(:a, '(more)', tabindex: '0', role: 'button', data: { toggle: 'popover', placement: 'bottom', trigger: 'focus', content: presentation.description })
      description + view_link
    else
      presentation.description
    end
  end

  #
  # Sets variables for Presentation feedback options/links
  # Handles differences between admin, presenter, and/or attendee users
  #
  def feedback_content(user:, presentation:)
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
  # Handles params for feedback button
  #
  def feedback_button(user, presentation)
    if is_in_future?(presentation)
      return if in_presentation_show?
      build_feedback_button('Available after Presentation', '#', 'btn btn-default disabled')
    elsif user_is_not_attendee?(user, presentation)
      build_feedback_button('See Feedback', presentation_responses_path(presentation), 'btn btn-success')
    elsif has_provided_feedback?(user, presentation)
      build_feedback_button('Feedback Submitted', '#', 'btn btn-success disabled')
    else
      build_feedback_button('Provide Feedback', new_presentation_response_path(presentation), 'btn btn-warning')
    end
  end

  #
  # Determine if in Presentations#show
  #
  def in_presentation_show?
    params[:controller] == 'presentations' && params[:action] == 'show'
  end

  #
  # Determine if user is an attendee (versus presenter or admin)
  #
  def user_is_not_attendee?(user, presentation)
    user.is_presenter?(presentation) || user.is_admin
  end

  #
  # Determine if a presentation is set in the future
  #
  def is_in_future?(presentation)
    (presentation.date - Time.now).positive?
  end

  #
  # Check if a user has provided feedback for a given presentation
  #
  def has_provided_feedback?(user, presentation)
    participation = Participation.where(user_id: user.id, presentation_id: presentation.id).first
    return unless participation.valid?
    participation.feedback_provided
  end

  #
  # Renders button for feedback based on params passed from feedback_button
  #
  def build_feedback_button(link_text, path, link_class)
    link_to link_text, path, class: link_class
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
  def presentation_options(user, presentation)
    participation = Participation.where(user_id: user.id, presentation_id: presentation.id).first
    return unless user.is_admin || participation.is_presenter
    presenter_presentation_options(presentation)
  end

  def admin_presentation_options(presentation)
    content_tag :div, class: 'admin-options' do
      edit_details_link = link_to 'Edit Details', edit_presentation_path(presentation), class: 'btn btn-primary'
      edit_participants_link = content_tag :button, 'Edit Participants', class: 'btn btn-primary', data: { toggle: 'modal', target: '.bs-example-modal-sm' }
      view_surveys_link = link_to 'View Surveys', presentation_surveys_path(presentation), class: 'btn btn-primary'
      delete_link = link_to 'Delete', presentation_path(presentation), class: 'btn btn-danger', method: :delete, data: { confirm: 'Are you sure you want to delete this presentation?' }

      edit_details_link + edit_participants_link + view_surveys_link + delete_link
    end
  end

  def presenter_presentation_options(presentation)
    content_tag :div, class: 'admin-options' do
      view_surveys_link = link_to 'View Surveys', presentation_surveys_path(presentation), class: 'btn btn-primary'
    end
  end

  #
  # Renders partial of Participation table
  # Handles if user is presenter or attendee
  #
  def participation_table(role:, participations:)
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
