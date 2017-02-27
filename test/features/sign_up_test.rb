require "test_helper"

class SignUpTest < Capybara::Rails::TestCase

  feature "Sign Up" do
    before do
      visit root_path
      click_on "Sign Up"
    end

    scenario "has valid content" do
      within ("form") do
        fill_in "Email", with: "user@example.com"
        fill_in "First name", with: "First"
        fill_in "Last name", with: "Last"
        fill_in "Password", with: "testing"
        fill_in "Password confirmation", with: "testing"
        click_button "Sign Up"
      end
      assert_equal current_path, root_path
    end

    scenario "had invalid content" do
      within ("form") do
        fill_in "Email", with: "user@example.com"
        fill_in "First name", with: "First"
        fill_in "Last name", with: "Last"
        fill_in "Password", with: "password"
        fill_in "Password confirmation", with: "badpassword"
        click_button "Sign Up"
      end
      page.must_have_content "Password confirmation doesn't match Password"
    end
  end
  #
  # feature "Sign In" do
  #
  # end
end
