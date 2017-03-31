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

  describe '#show' do
    it 'redirects to the presentation survey show page' do
      get(:show, params:
                      {
                        presentation_id: @presentation.id,
                        survey_id: @survey.id,
                        id: @question.id
                      })

      assert_redirected_to presentation_survey_path(@presentation, @survey)
    end
  end

  describe '#new' do
    before do
      get(:new, params: { survey_id: @survey.id, presentation_id: @presentation.id })
    end

    it 'sets survey variable as an instance variable' do
      survey = assigns(:survey)

      assert_equal survey, @survey, 'Does not set the survey instance variable'
    end

    it 'sets an unsaved question as an instance variable' do
      question = assigns(:question)

      refute_nil question, 'Expected question instance variable to exist'
      assert question.new_record?, 'Expected question to be a new record'
    end
  end

  describe '#edit' do
    before do
      get(:edit, params: {
            survey_id: @survey.id,
            presentation_id: @presentation.id,
            id: @question.id
          })
    end

    it 'sets survey variable as an instance variable' do
      survey = assigns(:survey)

      assert_equal survey, @survey, 'Does not set the survey instance variable'
    end

    it 'sets presentation variable as an instance variable' do
      presentation = assigns(:presentation)

      assert_equal presentation, @presentation, 'Does not set the presentation instance variable'
    end

    it 'sets question variable as an instance variable' do
      question = assigns(:question)

      assert_equal question, @question, 'Does not set the survey instance variable'
    end
  end

  describe '#create' do
    let(:success_params) do
      {
        presentation_id: @presentation.id,
        survey_id: @survey.id,
        question: {
          position: 1,
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
          position: nil,
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

      assert_equal @initial_count, Question.count, "Expected Question count(#{Question.count}) to be equal to initial count(#{@initial_count})."
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
          prompt: new_prompt
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
