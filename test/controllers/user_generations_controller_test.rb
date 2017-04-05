require "test_helper"

class UserGenerationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create :user, :admin
    sign_in @admin
  end

  describe '#new' do
    it 'sets user as an instance variable' do
      get :new
      user = assigns(:user)

      refute_nil user, 'Expected @user to exist'
    end
  end

  describe '#create' do
    before do
      @initial_count = User.count
    end

    it 'creates a new user from valid parameters' do
      post :create, params: {
        user: {
          first_name: "First",
          last_name: "Last",
          email: "email@example.com"
        }
      }

      assert User.count > @initial_count, 'Expected a new user to be created'
    end

    it 'does not create a new user from invalid parameters' do
      post :create, params: {
        user: {
          first_name: "",
          last_name: "",
          email: ""
        }
      }

      assert_equal User.count, @initial_count, 'Did not expect the number of users to change'
    end
  end
end
