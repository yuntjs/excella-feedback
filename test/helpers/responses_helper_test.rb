require 'test_helper'

class ResponsesHelperTest < ActionView::TestCase
  before do
    @user = create(:user)

    @text_question = create(:question, :text, :required)
    @number_question = create(:question, :number, :required)

    @text_response = build(:response, :text, question_id: @text_question.id)
    @number_response = build(:response, :number, question_id: @number_question.id)

    @error_class = 'has-error'

    @invalid_text_response = build(:response, :text, question_id: @text_question.id)
    @invalid_number_response = build(:response, :number, question_id: @number_question.id)

    @invalid_text_response.errors.add(:require_question, :unique_response)
    @invalid_number_response.errors.add(:require_question, :unique_response)
  end

  describe '#display_question' do
    it 'renders text form partial if response type is "text"'

    it 'renders scale form partial if response type is "number"'

    it 'raises an error if response type is not valid' do
      invalid_question = create(:question, :required, response_type: 'invalid')
      invalid_response = create(:response, :text, question_id: invalid_question.id)

      assert_raises(ArgumentError) { display_question(invalid_response) }
    end
  end

  describe '#scale_response_match' do
    before do
      @number_response.value = '3'
      @number_response.save
    end

    it 'returns true if response.value matches value' do
      assert scale_response_match(@number_response, '3')
    end

    it 'returns false if response.value does not match value' do
      refute scale_response_match(@number_response, '4')
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
