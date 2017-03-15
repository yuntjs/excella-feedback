require 'test_helper'

class ResponsesControllerTest < ActionController::TestCase
  include FactoryGirl::Syntax::Methods

  describe '#index' do
    it 'should show all responses' do
    pres = create(:presentation)
    survey = create :survey, presentation_id: pres.id
    question = create(:question, survey_id: survey.id)
    response1 = create(:response, question_id: question.id)

    # get :index
    assert_equal pres.surveys.first.questions.first.responses, [response1], 'Did not return any Responses'
    end
  end

  describe '#create' do
    it 'should require neccessary validators' do
      response = build(:response, :invalid)

      assert_not response.valid?
      assert_equal [:question, :user, :question_id, :user_id, :value], response.errors.keys
    end

    it 'should only allow a user to save a response to a question once' do
      user = create(:user)
      question = create(:question)

      response1 = create(:response, user_id: user.id, question_id: question.id)
      response2 = build(:response, user_id: user.id, question_id: question.id)

      assert response2.invalid?, 'Response saved twice with same user_id and question_id'
      assert_equal [:unique_response], response2.errors.keys
    end
  end
end
