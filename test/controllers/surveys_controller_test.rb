require "test_helper"

class SurveysControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include FactoryGirl::Syntax::Methods

    describe '#create' do
      it "Should create a new survey if User is an Admin" do
        #Arrange
        admin = create :user, :admin
        presentation = create :presentation

        sign_in admin

        #Act
        post :create, params: {presentation_id: presentation.id, survey:{ order: 1, subject: "Git"}}

        #Assert
        assert_redirected_to presentation_survey_path(presentation.id, presentation.surveys.first.id), "Create method unsuccessful, no redirect to presentations_survey_path"

      end
    end
  end
