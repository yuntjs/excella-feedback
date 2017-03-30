#
# ApplicationController
#
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  #
  # Protect admin-only paths
  #
  def authenticate_admin
    return if current_user&.is_admin
    redirect_to presentations_path
  end

  #
  # Protect presenter paths from general users
  #
  def authenticate_admin_or_presenter
    @presentation = Presentation.find(params[:presentation_id])
    return if current_user&.is_admin || current_user&.is_presenter?(@presentation)
    redirect_to presentations_path
  end

  #
  # Define success message for notices
  # TODO: accomodate this for actions that don't end with the letter 'e'
  #
  def success_message(object, action)
    "#{object.class.name.underscore.humanize} has been successfully #{action}d."
  end

  #
  # Define error message for notices
  #
  def error_message(object, action)
    "We ran into some errors while trying to #{action} this"\
    " #{object.class.name.underscore.humanize.downcase}. Please try again."
  end

  #
  # Assign params for new default survey
  #
  def new_default_survey(subject)
    if subject.class == Presentation
      survey = create_overall_survey(@presentation)
    elsif subject.class == User
      presentation = Presentation.find(@participation.presentation_id)
      survey = create_presenter_survey(presentation, subject)
    end

    questions = assign_default_questions(subject)
    create_default_survey(survey, questions)
  end

  #
  # Create 'Overall Presentation' Survey
  #
  def create_overall_survey(presentation)
    presentation.surveys.create(
      title: 'Overall Presentation',
      position: Survey.highest_position(presentation) + 1
    )
  end

  #
  # Create feedback survey for a specific user
  #
  def create_presenter_survey(presentation, presenter)
    presentation.surveys.create(
      title: "Feedback for #{presenter.full_name}",
      position: Survey.highest_position(presentation) + 1,
      presenter_id: presenter.id
    )
  end

  #
  # Create survey questions based on survey subject (presenter or presentation)
  #
  def assign_default_questions(subject)
    if subject.class == Presentation
      Question.default_presentation_questions
    elsif subject.class == User
      Question.default_presenter_questions(subject)
    end
  end

  #
  # Create default survey and populate with default questions
  # for either a Presentation or an individual Presenter
  # Default questions are in Question Model
  #
  def create_default_survey(survey, questions)
    questions.each do |question|
      survey.questions.create(
        prompt: question[:prompt],
        response_type: question[:response_type],
        response_required: true,
        position: Question.highest_position(survey) + 1
      )
    end
  end
end
