module ResponsesHelper
  # Determine which partial to render based on a question's response type
  def display_question(response)
    case response.question.response_type
    when 'text'
      render 'text_form_partial', response: response
    when 'number'
      render 'scale_form_partial', response: response
    else
    end
  end
end
