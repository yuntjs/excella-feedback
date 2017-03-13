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
      render 'text_form_partial', response: response
    when 'number'
      render 'scale_form_partial', response: response
    else
    end
  end

  #
  # Display text response if response.value exists
  #
  def display_text_response(response)
    response.value ? response.value : nil
  end

  #
  # Display boolean depending on if response.value matches given value
  #
  def display_scale_response(response, value)
    response.value == value ? true : false
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
          render_list(response.errors.full_messages)
        ),
        class: 'has-error'
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
