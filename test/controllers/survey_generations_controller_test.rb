require 'test_helper'

class SurveyGenerationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    admin = create(:user, :admin)
    sign_in(admin)

    @presentation = create(:presentation)
    @survey_template = create(:survey_template)

    create_list(:question_template, 2, :number, :required, survey_template_id: @survey_template.id)
    create_list(:question_template, 2, :text, :optional, survey_template_id: @survey_template.id)
  end

  describe '#create' do
    before do
      post(:create, params: {
             presentation_id: @presentation.id,
             survey_template_id: @survey_template.id
           })
    end

    it 'creates a survey from a valid survey template' do
      survey = Survey.first
      assert_equal(Survey.count, 1, 'A survey was not generated from a survey template')
    end

    it 'creates questions from a valid set of question templates' do
      assert_equal(Question.count, QuestionTemplate.count, 'Questions were not created from valid question templates')
    end

    it 'redirects to presentation_surveys_path' do
      assert_redirected_to(presentation_surveys_path(@presentation))
    end
  end
end
