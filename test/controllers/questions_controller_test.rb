require "test_helper"

class QuestionsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include FactoryGirl::Syntax::Methods

  describe '#create' do
    it "Should create a new question if User is an Admin" do
      admin = create :user, :admin
      presentation = create :presentation
      survey = create :survey, order: 1, subject: "Git", presentation_id: presentation.id
      question = create :question

      sign_in admin

      post :create, params: { presentation_id: presentation.id, survey_id: survey.id, question:{ order: question.order, prompt: question.prompt, response_type: question.response_type } }
      assert_redirected_to presentation_survey_path(presentation.id, survey.id), "Create method unsuccessful, no redirect to presentation_survey_path"
    end
  end

  describe '#update' do
    it "Should allow admin to update questions" do
      admin = create :user, :admin
      presentation = create :presentation
      survey = create :survey, order: 1, subject: "Git", presentation_id: presentation.id
      question = create :question, survey_id: survey.id
      updated_prompt = "Feedback is an internal application that allows?"

      sign_in admin

      patch :update, params: {presentation_id: presentation.id, survey_id: survey.id, id: question.id, question:{prompt: updated_prompt}}
      question.reload

      assert_equal question.prompt, updated_prompt, "Update unsuccessful, values do not match"
    end
    it "Should redirect to correct path after an update" do
      admin = create :user, :admin
      presentation = create :presentation
      survey = create :survey, order: 1, subject: "Git", presentation_id: presentation.id
      question = create :question, survey_id: survey.id
      updated_prompt = "Feedback is an internal application that allows?"

      sign_in admin

      patch :update, params: {presentation_id: presentation.id, survey_id: survey.id, id: question.id, question:{prompt: updated_prompt}}
      assert_redirected_to presentation_survey_path(presentation.id, survey.id), "Update unsucessful, no redirect"
    end
  end
end
