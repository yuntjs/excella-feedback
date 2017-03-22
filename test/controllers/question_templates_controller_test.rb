require 'test_helper'

class QuestionTemplatesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create(:user, :admin)

    sign_in(@admin)

    @survey_template = create(:survey_template)
    @question_template_number = create(:question_template, :number, survey_template_id: @survey_template.id)
    @question_template_text = create(:question_template, :text, survey_template_id: @survey_template.id)
  end

  describe '#create' do
    
  end

  describe '#update' do
  end

  describe '#destroy' do
  end
end
