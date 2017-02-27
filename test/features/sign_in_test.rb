require "test_helper"

class SignInTest < Capybara::Rails::TestCase
  include FactoryGirl::Syntax::Methods

  feature "Sign In" do
    before do
      visit root_path
      click_on "Log In"
    end

    scenario "has valid content" do
      u = create :user
      within ("form") do
        fill_in "Email", with: u.email
        fill_in "Password", with: u.password
        click_button "Log In"
      end
      assert_equal current_path, root_path
    end

    scenario "has invalid password" do
      u = create :user
      within ("form") do
        fill_in "Email", with: u.email
        fill_in "Password", with: u.password + "_wrong"
        click_button "Log In"
      end
      assert_equal current_path, new_user_session_path
    end
  end
end
