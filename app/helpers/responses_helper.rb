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
    if response.errors.any?
      content_tag(:div,
        content_tag(:ul,
          render_list(response.errors.full_messages),
          class: "error-list"
        ),
        class: 'has-error text-danger'
      )
    end
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
end
