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
    it 'saves valid question templates' do
      post(:create, params: {
        survey_template_id: @survey_template.id,
        question_template: {
          prompt: 'prompt',
          response_type: 'number',
          response_required: false
        }
      })

      assert QuestionTemplate.count > 0, 'Expected question template count to be greater than zero'
    end

    it 'rejects invalid question templates' do
      post(:create, params: {
        survey_template_id: @survey_template.id,
        question_template: {
          prompt: nil,
          response_type: nil,
          response_required: false
        }
      })

      assert QuestionTemplate.count == 0, 'Expected question template count to be zero'
    end

    it 'redirects to the survey template path'
  end

  describe '#update' do
    it 'updates a question template if update data is valid'
    it 'does not update a question template if update data is invalid'
  end

  describe '#destroy' do
    it 'destroys a question template if it is valid'
    it 'does not destroy a question template if it is invalid'
  end
end
