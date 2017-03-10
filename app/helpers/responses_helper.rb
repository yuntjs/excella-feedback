module ResponsesHelper
  # Determine which partial to render based on a question's response type
  def display_question(response, response_form)
    case response.question.response_type
    when 'text'
      render 'text_form_partial', response: response, response_form: response_form
    when 'number'
      # render 'scale_form_partial', response: response, response_form: response_form
    else
    end
  end
end
