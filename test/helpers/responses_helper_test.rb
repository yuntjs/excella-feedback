require 'test_helper'

class ResponsesHelperTest < ActionView::TestCase
  before do
    @user = create(:user)

    @text_question = create(:question, :text)
    @number_question = create(:question, :number)

    @text_response = build(:response, :text, question_id: @text_question.id)
    @number_response = build(:response, :number, question_id: @number_question.id)

    @error_class = 'has-error'

    @invalid_text_response = build(:response,
                                   :text,
                                   question_id: @text_question.id)
    @invalid_number_response = build(:response,
                                     :number,
                                     question_id: @number_question.id)

    @invalid_text_response.errors.add(:require_question, :unique_response)
    @invalid_number_response.errors.add(:require_question, :unique_response)
  end

  describe '#display_question' do
    it 'renders text form partial if response type is "text"' do
    end

    it 'renders scale form partial if response type is "number"'

    it 'raises an error if response type is not valid'
  end

  describe '#scale_response_match' do
    it 'returns true if response.value matches value'

    it 'returns false if response.value does not match value'
  end

  describe '#error_class' do
    it 'returns a css class as a string when response has an error' do
      text_response = error_class(@invalid_text_response)
      number_response = error_class(@invalid_number_response)

      assert_equal text_response, @error_class, 'Text response with error does not return correct css error class.'
      assert_equal number_response, @error_class, 'Number response with error does not return correct css error class'
    end

    it 'returns an empty string when response does not contain an error' do
      text_response = error_class(@text_question)
      number_response = error_class(@number_question)

      assert text_response.empty?, "Does not return an empty string for a valid text response. Got: #{text_response}"
      assert number_response.empty?, "Does not return an empty string for a valid number response. Got: #{number_response}"
    end
  end

  describe '#error_messages' do
    it 'contains css error class' do
      text_response = error_messages(@invalid_text_response)
      number_response = error_messages(@invalid_number_response)

      assert text_response.include?(@error_class), 'Invalid text error message does not contain correct error class'
      assert number_response.include?(@error_class), 'Invalid number error message does not contain error class'
    end

    it 'returns nil for a response without errors' do
      text_response = error_messages(@text_response)
      number_response = error_messages(@number_response)

      assert text_response.nil?, 'Valid text response returned value other than nil'
      assert number_response.nil?, 'Valid number response returned value other than nil'
    end
  end

  describe '#render_list' do
    it 'returns each message in an array as a <li> element' do
      msg_array = ['Hello World', 'Hola Mundo', 'Dlrow Olleh', 'Odnum Aloh']

      raw_string = render_list(msg_array)
      list_length = raw_string.split('</li>').length

      assert raw_string.include?('<li>'), 'does not create any <li> elements'
      assert_equal msg_array.length, list_length, 'does not create <li> for each message.'
    end

    it 'works with error messages' do
      text_errors = @invalid_text_response.errors.full_messages
      number_errors = @invalid_number_response.errors.full_messages

      raw_text_string = render_list(text_errors)
      raw_number_string = render_list(number_errors)

      text_list_length = raw_text_string.split('</li>').length
      number_list_length = raw_number_string.split('</li>').length

      assert_equal text_errors.length, text_list_length, 'Text errors do not match resulting list'
      assert_equal number_errors.length, number_list_length, 'Number errors do not match resulting list'
    end
  end

  describe '#can_see_survey_results' do
    it 'returns true if a survey is not associated to a presenter' do
      survey = create(:survey)
      assert can_see_survey_results(survey, @user), 'survey.presenter_id is not nil'
    end

    it 'returns true if a user\'s id is not equal to the survey\'s presenter_id' do
      survey = create(:survey, presenter_id: @user.id)
      assert can_see_survey_results(survey, @user), 'survey.presenter_id does not match user.id'
    end

    it 'returns true if a user is an admin' do
      admin = create(:user, :admin)
      survey = create(:survey, presenter_id: @user.id)
      assert can_see_survey_results(survey, admin), 'user is not an admin'
    end
  end
end
