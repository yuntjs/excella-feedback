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
end
