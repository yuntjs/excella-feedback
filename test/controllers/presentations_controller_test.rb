require "test_helper"

class PresentationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  # Before actions
  before do
    @params = {
      title: "Test Presentation",
      location: "ATX",
      date: DateTime.new(2017, 2, 22),
      description: "Lorem ipsum",
      is_published: true,
    }
  end

  # Index tests
  describe "#index" do

    it "gets all presentations if you are an admin" do
      admin = create :user, :admin
      presentation = create :presentation
      sign_in admin
      get :index
      assert_equal Presentation.all, [presentation], "Did not return presentations"
    end

    it "gets only presentations for which a non-admin user is a participant" do
      u = create :user
      pres1 = create :presentation
      pres2 = create :presentation
      part = create :participation, user: u, presentation: pres1
      sign_in u
      get :index
      assert_equal u.presentations, [pres1], "Returned presentation for which the user is not a participant"
    end
  end

  # Create tests
  describe "#create" do

    it "redirects to index page if logged in" do
      user = User.create(
        email: "nicholas.oki@excella.com",
        password: "testing",
        password_confirmation: "testing",
        first_name: "Nick",
        last_name: "Oki"
      )
      sign_in user
      post :create, params: @params
      assert_redirected_to presentations_path, "Create method unsuccessful, no redirect to presentations_path"
    end

    it "redirects to sign in if no current_user" do
      post :create, params: @params
      assert_redirected_to new_user_session_path
    end
  end

  # Edit tests

  # Delete tests

end
