require 'test_helper'

class ResponsesControllerTest < ActionController::TestCase
  include FactoryGirl::Syntax::Methods

  describe '#create' do
    it 'should require neccessary validators' do
      response = build(:response, :invalid)

      assert_not response.valid?
      assert_equal [:question, :user, :question_id, :user_id, :value], response.errors.keys
    end

    it 'should only allow a user to save a response to a question once' do
      user = create(:user)
      question = create(:question)

      response_1 = create(:response, user_id: user.id, question_id: question.id)
      response_2 = build(:response, user_id: user.id, question_id: question.id)

      assert response_2.invalid?, 'Response saved twice with same user_id and question_id'
      assert_equal [:unique_response], response_2.errors.keys
    end
  end
end
