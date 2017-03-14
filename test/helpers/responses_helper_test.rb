require 'test_helper'

class ResponsesHelperTest < ActionView::TestCase
  # include Devise::Test::ControllerHelpers

  before do
    @user = create(:user)

    @text_question = create(:question, :text)
    @number_question = create(:question, :number)

    @text_response = build(:response, :text, question_id: @text_question.id)
    @number_response = build(:response, :number, question_id: @number_question.id)
  end

  describe '#display_question' do
    it 'renders text form partial if response type is "text"'

    it 'renders scale form partial if response type is "number"'

    it 'raises an error if response type is not valid'
  end

  describe '#scale_response_match' do
    it 'returns true if response.value matches value'

    it 'returns false if response.value does not match value'
  end

  describe '#error_class' do
    it 'returns a css class as a string when response has an error' do
      text = build(:response,
        :text,
        question_id: @text_question.id)
      number = build(:response,
        :number,
        question_id: @number_question.id)

      text.errors.add(:require_question)
      number.errors.add(:require_question)

      text_response = error_class(text)
      number_response = error_class(number)

      assert_equal text_response, 'has-error', 'Text response with error does not return correct css error class.'
      assert_equal number_response, 'has-error', 'Number response with error does not return correct css error class'
    end

    it 'returns an empty string when response does not contain an error' do
      text_response = error_class(@text_question)
      number_response = error_class(@number_question)

      assert text_response.empty?, "Does not return an empty string for a valid text response. Got: #{text_response}"
      assert number_response.empty?, "Does not return an empty string for a valid number response. Got: #{number_response}"
    end
  end
end
