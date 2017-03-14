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
end
