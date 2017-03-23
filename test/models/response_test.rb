#
# Response model test
#
require 'test_helper'

describe Response do
  before do
    @user = create(:user)
    @question = create(:question, :text, :required)
  end

  describe '#unique_response' do
    it 'passes validation if response is unique' do
      response = build(:response, :text, :optional)

      assert_nil response.unique_response
    end

    it 'adds errors to response if it was already recorded' do
      response = create(:response, :text, :required)
      duplicate_response = build(:response,
                                 user_id: response.user_id,
                                 question_id: response.question_id)

      duplicate_response.unique_response

      refute_empty duplicate_response.errors
    end
  end

  describe '#require_question' do
    it 'passes validation if response is not required for question' do
      response = build(:response, :text, response_required: false)

      assert_nil response.require_question
    end

    it 'passes validation if response is required but has a value' do
      question_required = create(:question, :text, :required)
      response = build(:response, value: 'exists', question_id: question_required.id)

      assert_nil response.require_question
    end

    it 'adds errors to response if it is required and does not have a value' do
      question_required = create(:question, :text, :required)
      response = build(:response, value: nil, question_id: question_required.id)

      response.require_question

      refute_empty response.errors
    end
  end
end
