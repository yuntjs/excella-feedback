require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create(:user, :admin)

    sign_in(@admin)

    @presentation = create(:presentation)
    @survey = create(:survey, position: 1, title: 'Git', presentation_id: @presentation.id)
    @question = create(:question, :number, :required, survey_id: @survey.id)
  end

  describe '#index' do
    it 'redirects to the presentation survey show page' do
      get(:index, params: { presentation_id: @presentation.id, survey_id: @survey.id })

      assert_redirected_to presentation_survey_path(@presentation, @survey)
    end
  end

  describe '#create' do
    let(:success_params) do
      {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        question: {
          prompt: 'prompt',
          response_type: 'number',
          response_required: false
        }
      }
    end

    let(:error_params) do
      {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        question: {
          prompt: nil,
          response_type: nil,
          response_required: false
        }
      }
    end

    before do
      @initial_count = Question.count
    end

    it 'saves valid new question' do
      post(:create, params: success_params)

      assert @initial_count < Question.count, "Expected Question count(#{Question.count}) to be greater than initial count(#{@initial_count})."
    end

    it 'rejects invalid new questions' do
      post(:create, params: error_params)

      assert @initial_count == Question.count, "Expected Question count(#{Question.count}) to be equal to initial count(#{@initial_count})."
    end

    it 'redirects to presentation_survey_path after saving' do
      post(:create, params: success_params)

      assert_redirected_to(presentation_survey_path(@presentation.id, @survey.id), 'No redirect to presentation_survey_path')
    end
  end

  describe '#update' do
    let(:old_prompt) { @question.prompt }
    let(:new_prompt) { 'This is the new prompt' }

    let(:success_params) do
      {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        id: @question.id,
        question: {
          prompt: new_prompt,
        }
      }
    end

    let(:error_params) do
      {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        id: @question.id,
        question: {
          prompt: nil,
          response_type: nil,
          response_required: false
        }
      }
    end

    it 'updates a question with valid data' do
      patch(:update, params: success_params)

      @question.reload

      assert_equal @question.prompt, new_prompt, 'Question prompt before & after update do not match'
    end

    it 'does not update a question with invalid data' do
      patch(:update, params: error_params)

      @question.reload

      assert_equal @question.prompt, old_prompt, 'Question prompt was updated when data was invalid'
    end

    it 'redirects to correct path after a successful update' do
      patch(:update, params: success_params)

      assert_redirected_to(presentation_survey_path(@presentation.id, @survey.id), 'No redirection to presentation_survey_path')
    end
  end

  describe '#destroy' do
    let(:params) do
      {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        id: @question.id
      }
    end

    before do
      @initial_count = Question.count
    end

    it 'deletes a question' do
      delete(:destroy, params: params)

      assert_equal Question.count, @initial_count - 1, 'Failed to delete question'
    end
  end
end
