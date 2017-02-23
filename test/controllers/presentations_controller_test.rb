require "test_helper"

class PresentationsControllerTest < ActionController::TestCase
include Devise::Test::ControllerHelpers
# describe PresentationsController, type: :controller do
  before do
    @params = {
      title: "Test Presentation",
      location: "ATX",
      date: DateTime.new(2017, 2, 22),
      description: "Lorem ipsum",
      is_published: true,
    }
  end

  # describe "#index" do
  #   it "gets all presentations" do
  #     # Arrange
  #
  #     # Act
  #     get :index
  #     # Assert
  #     assert_includes :index.presentations, @presentation, "Did not return presentations"
  #   end
  # end


  describe "#create" do
    it "redirects to index page if logged in" do
      # Arrange
      user = User.create(
        email: "nicholas.oki@excella.com",
        password: "testing",
        password_confirmation: "testing",
        first_name: "Nick",
        last_name: "Oki"
      )
      sign_in user
      # Act
      post :create, params: @params
      # Assert
      assert_redirected_to presentations_path, "Create method unsuccessful, no redirect to presentations_path"
    end

    it "redirects to sign in if no current_user" do
      # Arrange

      # Act
      post :create, params: @params
      # Assert
      assert_redirected_to new_user_session_path

    end
  end

end
