#
# ResponsesHelper
#
module ResponsesHelper
  #
  # Determine which partial to render based on a question's response type
  #
  def display_question(response)
    case response.question.response_type
    when 'text'
      render partial: 'text_form_partial', locals: { response: response }
    when 'number'
      render partial: 'scale_form_partial', locals: { response: response }
    else
      raise ArgumentError, 'Unknown response type'
    end
  end

  #
  # Display boolean depending on if response.value matches given value
  #
  def scale_response_match(response, value)
    response.value == value
  end

  #
  # Add error class if response has errors
  #
  def error_class(response)
    response.errors.any? ? 'has-error' : ''
  end

  #
  # Add list of errors below response
  #
  def error_messages(response)
    return unless response.errors.any?
    content_tag(:div,
                content_tag(:ul,
                            render_list(response.errors.full_messages),
                            class: 'error-list'),
                class: 'has-error text-danger')
  end

  #
  # Provides all messages from an array as <li>
  #
  def render_list(messages)
    result = ''
    messages.each do |msg|
      result += content_tag(:li, msg)
    end
    result.html_safe
  end

  #
  # Renders response to text question
  #
  def render_comment(response)
    return if response.value.empty?
    content_tag(:li, response.value, class: 'list-group-item')
  end

  #
  # Filter based on user permissions (admin, presenter)
  # Presenters can only see overall data and their own surveys
  # Admins can see all
  #
  def can_see_survey_results(survey, user)
    survey.presenter_id.nil? || user.is_admin || survey.presenter_id == user.id
  end
end
