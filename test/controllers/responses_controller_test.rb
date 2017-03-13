require 'test_helper'

class ResponsesControllerTest < ActionController::TestCase
  # include FactoryGirl::Syntax::Methods
  include Devise::Test::ControllerHelpers

  before do
    @user = create :user
    @presentation = create :presentation
    @survey = create :survey, order: 1, subject: 'Git', presentation_id: @presentation.id
    @questions = create_list :question, 5, :required, :number, survey_id: @survey.id
    sign_in @user
  end

  describe '#new' do
    it 'creates multiple response objects from questions for the view' do
      get :new, params: { presentation_id: @presentation.id }
      assert_equal @questions.length, assigns(:responses).length
    end
  end

#MOVE TO MODEL TESTS
  # describe '#create' do
  #   it 'should require neccessary validators' do
  #     response = build(:response, :invalid)
  #
  #     assert_not response.valid?
  #     assert_equal [:question, :user, :question_id, :user_id, :value], response.errors.keys
  #   end
  #
  #   it 'should only allow a user to save a response to a question once' do
  #     user = create(:user)
  #     question = create(:question)
  #
  #     response1 = create(:response, user_id: user.id, question_id: question.id)
  #     response2 = build(:response, user_id: user.id, question_id: question.id)
  #
  #     assert response2.invalid?, 'Response saved twice with same user_id and question_id'
  #     assert_equal [:unique_response], response2.errors.keys
  #   end
  # end
end
