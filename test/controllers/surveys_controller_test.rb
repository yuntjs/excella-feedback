require "test_helper"

class SurveysControllerTest < ActionController::TestCase
  include FactoryGirl::Syntax::Methods

  # describe "#show" do
  #   it "Brings user to survey#show if they are part of the presentation" do
  #     #Arrange
  #     u = create :user
  #     pres1 = create :presentation
  #     pres2 = create :presentation
  #       # Add a join bw user and presentation
  #     part = create :participation, user: u, presentation: pres1
  #     # sign_in u
  #     #Act
  #     get "presentations/#{pres1.id}/surveys"
  #     #Assert
  #     assert_template "surveys/#{pres1.id}"
  #   end
    # it "Redirects to presentations#index if user is not part of the presentation" do
    #
    # end
    describe '#new' do
      it "Should create a new survey if User is an Admin" do
        #Arrange
          admin = create :user, :admin
          presentation = create :presentation
          survey1 = create :survey
        #Act
        post :survey, params: params[survey1]
        #Assert
        assert_redirected_to presentation_survey_path
      end
    end
  end
