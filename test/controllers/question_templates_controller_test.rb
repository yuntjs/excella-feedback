require 'test_helper'

class QuestionTemplatesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create(:user, :admin)

    sign_in(@admin)

    @survey_template = create(:survey_template)
    @question_template_number = create(:question_template, :number, :required, survey_template_id: @survey_template.id)
    @question_template_text = create(:question_template, :text, :required, survey_template_id: @survey_template.id)

    @initial_count = QuestionTemplate.count

    @success_params = {
      survey_template_id: @survey_template.id,
      question_template: {
        prompt: 'prompt',
        response_type: 'number',
        response_required: false
      }
    }
    @error_params = {
      survey_template_id: @survey_template.id,
      question_template: {
        prompt: nil,
        response_type: nil,
        response_required: false
      }
    }
  end

  describe '#create' do
    it 'saves valid question templates' do
      post(:create, params: @success_params)

      assert QuestionTemplate.count > @initial_count, 'Expected question template count to be greater than initial count'
    end

    it 'rejects invalid question templates' do
      post(:create, params: @error_params)

      assert QuestionTemplate.count == @initial_count, 'Expected question template count to be equal to the initial count'
    end

    it 'redirects to the survey template path when saves correctly' do
      post(:create, params: @success_params)

      assert_redirected_to survey_template_path(@survey_template)
    end

    it 'redirects to the survey template path when save fails' do
      post(:create, params: @error_params)

      assert_redirected_to survey_template_path(@survey_template)
    end
  end

  describe '#update' do
    it 'updates a question template if update data is valid' do
      new_prompt = 'new prompt'

      patch(:update, params: {
        survey_template_id: @survey_template.id,
        id: @question_template_text.id,
        question_template: { prompt: new_prompt }
      })
      
      @question_template_text.reload

      assert_equal @question_template_text.prompt, new_prompt, 'Question template has not been updated'
    end
    it 'does not update a question template if update data is invalid'
  end

  describe '#destroy' do
    it 'destroys a question template if it is valid'
    it 'does not destroy a question template if it is invalid'
  end
end
