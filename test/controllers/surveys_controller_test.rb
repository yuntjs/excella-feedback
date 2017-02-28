require "test_helper"

class SurveysControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include FactoryGirl::Syntax::Methods

    describe '#create' do
      it "Should create a new survey if User is an Admin" do
        admin = create :user, :admin
        presentation = create :presentation

        sign_in admin
        post :create, params: {presentation_id: presentation.id, survey:{ order: 1, subject: "Git"}}
        assert_redirected_to presentation_survey_path(presentation.id, presentation.surveys.first.id), "Create method unsuccessful, no redirect to presentations_survey_path"

      end
    end

    describe '#update' do
      it "Should allow Admin user to Update surveys" do
        admin = create :user, :admin
        presentation = create :presentation
        survey1 = presentation.surveys.create(order: 1, subject: "Git")

        updated_subject = "Git 2"
        updated_order = 2

        sign_in admin
        patch :update, params: {presentation_id: presentation.id, id: presentation.surveys.first.id, survey:{order: updated_order, subject: updated_subject}}
        assert_redirected_to presentation_survey_path(presentation.id, presentation.surveys.first.id)

      end
    end
  end
