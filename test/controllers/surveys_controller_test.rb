require "test_helper"

class SurveysControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include FactoryGirl::Syntax::Methods

  describe "#create" do
    it "should create a new survey if User is an Admin" do
      admin = create(:user, :admin)
      presentation = create(:presentation)

      sign_in admin

      post :create, params: {
        presentation_id: presentation.id,
        survey: {
          order: 1,
          subject: "Git"
          }
        }

      assert_redirected_to presentation_survey_path(presentation.id, presentation.surveys.first.id), "No redirect to presentations_survey_path"
    end
  end

  describe "#update" do
    it "should allow Admin user to Update surveys" do
      admin = create :user, :admin
      presentation = create :presentation
      survey = create :survey, subject: "Git", presentation_id: presentation.id

      updated_subject = "Git 2"
      updated_position = 2

      sign_in admin

      patch :update, params: {
        presentation_id: presentation.id,
        id: survey.id,
        survey: {
          position: updated_position,
          subject: updated_subject
        }
      }

      survey.reload
      assert_equal [updated_subject, updated_position], [survey.subject, survey.position], "Survey subject & position was not updated properly"
      assert_redirected_to presentation_survey_path(presentation.id, survey.id), "No redirect to presentation_survey_path"
    end
  end

  describe "#destroy" do
    it "should allow Admin user to Delete surveys" do
      admin = create :user, :admin
      presentation = create :presentation
      survey = create :survey, presentation_id: presentation.id

      sign_in admin

      delete :destroy, params: {
        presentation_id: presentation.id,
        id: survey.id
      }

      assert_equal Survey.count, 0, "Delete method unsuccessful. Survey still exists."
    end
  end
end
