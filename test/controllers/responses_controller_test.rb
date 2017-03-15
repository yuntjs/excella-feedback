require 'test_helper'

class ResponsesControllerTest < ActionController::TestCase
  # include FactoryGirl::Syntax::Methods
  include Devise::Test::ControllerHelpers

  before do
    @user = create :user
    @presentation = create :presentation
    @survey = create :survey, position: 1, subject: 'Git', presentation_id: @presentation.id
    @questions = create_list :question, 5, :required, :number, survey_id: @survey.id

    sign_in @user
  end

  describe '#new' do
    it 'creates multiple unsaved response objects from questions for the view' do
      get :new, params: { presentation_id: @presentation.id }
      feedback = assigns(:feedback)
      assert_equal @questions.length, feedback.first[:responses].length
    end
  end

  describe '#create' do
    it 'creates responses if they are valid' do
      create(:participation,
        user_id: @user.id,
        presentation_id: @presentation.id
      )

      question_value_pairs = {}
      @questions.each do |question|
        question_value_pairs[question.id.to_s] = '1'
      end

      post :create, params: {
        presentation_id: @presentation.id,
        responses: {
          question_id: question_value_pairs
        }
      }

      assert_equal @questions.length, Response.all.length, 'Did not create a response for each question'
      assert_redirected_to presentation_path(@presentation), 'No redirect to presentation_path'
    end

    it 'does not save any responses if any are invalid' do
      question_value_pairs = {}
      @questions.each do |question|
        question_value_pairs[question.id.to_s] = '1'
      end

      question_value_pairs[@questions.first.id.to_s] = ''
      question_value_pairs[@questions.last.id.to_s] = ''

      assert Response.all.empty?, 'Invalid responses created'
      # TODO: assert_template :new not working
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
