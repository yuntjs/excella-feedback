require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create :user, :admin
    @presentation = create :presentation
    @survey = create :survey, position: 1, title: 'Git', presentation_id: @presentation.id
    @question = create :question, survey_id: @survey.id
  end

  describe '#create' do
    it 'should create a new question if User is an Admin' do
      question = create :question

      sign_in @admin

      post :create, params: {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        question: {
          position: question.position,
          prompt: question.prompt,
          response_type: question.response_type
        }
      }

      assert_redirected_to presentation_survey_path(@presentation.id, @survey.id), 'No redirect to presentation_survey_path'
    end
  end

  describe '#update' do
    it 'should allow admin to update questions' do
      updated_prompt = 'Feedback is an internal application that allows?'

      sign_in @admin

      patch :update, params: {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        id: @question.id,
        question: {
          prompt: updated_prompt
        }
      }

      @question.reload

      assert_equal @question.prompt, updated_prompt, 'Question prompt before & after update do not match'
    end

    it 'should redirect to correct path after an update' do
      updated_prompt = 'Feedback is an internal application that allows?'

      sign_in @admin

      patch :update, params: {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        id: @question.id,
        question: {
          prompt: updated_prompt
        }
      }

      assert_redirected_to presentation_survey_path(@presentation.id, @survey.id), 'No redirection to presentation_survey_path'
    end
  end
end
