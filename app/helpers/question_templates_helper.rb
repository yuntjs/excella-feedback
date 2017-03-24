#
# QuestionTemplatesHelper
#
module QuestionTemplatesHelper
  #
  # Add error class if question_template[error_attribute] has errors
  #
  def error_class(response)
    response.errors.any? ? 'has-error' : ''
  end

  #
  # Get list of question_template[error_attribute] errors
  #
  def error_messages(response)
    return unless response.errors.any?
    content_tag(:div,
                content_tag(:ul,
                            render_list(response.errors.full_messages),
                            class: 'error-list'),
                class: 'has-error text-danger')
  end
end
