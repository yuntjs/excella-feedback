require 'test_helper'

class QuestionTemplatesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create(:user, :admin)

    sign_in(@admin)

    @survey_template = create(:survey_template)
    @question_template_number = create(:question_template, :number, :required, survey_template_id: @survey_template.id)
    @question_template_text = create(:question_template, :text, :required, survey_template_id: @survey_template.id)
  end

  describe '#create' do
    let(:success_params) do
      {
        survey_template_id: @survey_template.id,
        question_template: {
          prompt: 'prompt',
          response_type: 'number',
          response_required: false
        }
      }
    end
    let(:error_params) do
      {
        survey_template_id: @survey_template.id,
        question_template: {
          prompt: nil,
          response_type: nil,
          response_required: false
        }
      }
    end

    before do
      @initial_count = QuestionTemplate.count
    end

    it 'saves valid question templates' do
      post(:create, params: success_params)

      assert QuestionTemplate.count > @initial_count, "Expected question template count (#{QuestionTemplate.count}) to be greater than initial count (#{@initial_count})"
    end

    it 'rejects invalid question templates' do
      post(:create, params: error_params)

      assert_equal QuestionTemplate.count, @initial_count, "Expected question template count (#{QuestionTemplate.count}) to equal initial count (#{@initial_count})"
    end

    it 'redirects to the survey template path when saves correctly' do
      post(:create, params: success_params)

      assert_redirected_to survey_template_path(@survey_template), 'Expected to redirect to survey_template_path'
    end

    it 'redirects to the survey template path when save fails' do
      post(:create, params: error_params)

      assert_redirected_to survey_template_path(@survey_template), 'Expected to redirect to survey_template_path'
    end
  end

  describe '#update' do
    let(:old_prompt) { @question_template_text.prompt }
    let(:new_prompt) { '3' }

    let(:success_params) do
      {
        survey_template_id: @survey_template.id,
        id: @question_template_text.id,
        question_template: {
          prompt: new_prompt,
          response_type: 'number',
          response_required: true
        }
      }
    end
    let(:error_params) do
      {
        survey_template_id: @survey_template.id,
        id: @question_template_text.id,
        question_template: {
          prompt: nil,
          response_type: nil,
          response_required: nil
        }
      }
    end

    it 'updates a question template if update data is valid' do
      patch(:update, params: success_params)

      @question_template_text.reload

      assert_equal @question_template_text.prompt, new_prompt, 'Question template has not been updated'
    end

    it 'does not update a question template if update data is invalid' do
      patch(:update, params: error_params)

      @question_template_text.reload

      assert_equal @question_template_text.prompt, old_prompt, 'Question template has been updated with invalid parameters'
    end

    it 'redirects to the survey template path when updated correctly' do
      patch(:update, params: success_params)

      assert_redirected_to survey_template_path(@survey_template), 'Expected to redirect to survey_template_path'
    end

    it 'redirects to the survey template path when update fails' do
      patch(:update, params: error_params)

      assert_redirected_to survey_template_path(@survey_template), 'Expected to redirect to survey_template_path'
    end
  end

  describe '#destroy' do
    let(:params) do
      {
        survey_template_id: @survey_template.id,
        id: @question_template_text.id
      }
    end

    before do
      @initial_count = QuestionTemplate.count
    end

    it 'destroys a question template' do
      delete(:destroy, params: params)

      assert_equal QuestionTemplate.count, @initial_count - 1, 'Expected question template count to decrease by 1'
      assert_raises { QuestionTemplate.find(@question_template_text.id) }, 'Expected QuestionTemplate.find to raise an error'
    end
  end
end
