#
# Response model test
#
require 'test_helper'

describe Response do
  before do
    @user = create(:user)
    @question = create(:question)
  end

  describe '#unique_response' do
    it 'passes validation if response is unique' do
      response = build(:response)

      assert_nil response.unique_response
    end

    it 'adds errors to response if it was already recorded' do
      response = create(:response)
      duplicate_response = build(:response,
        user_id: response.user_id,
        question_id: response.question_id
      )

      duplicate_response.unique_response

      refute_empty duplicate_response.errors
    end
  end

  describe '#require_question' do
    it 'passes validation if response is not required for question'
    it 'passes validation if response is required but has a value'
    it 'adds errors to response if it is required and does not have a value'
  end
end
