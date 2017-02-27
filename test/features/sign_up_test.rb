require "test_helper"

class SignUpTest < Capybara::Rails::TestCase
  feature "Sign Up" do
    scenario "has valid content" do
      visit root_path
      click_on "Sign Up"

      within ("form") do
        fill_in "Email", with: "user@example.com"
        fill_in "First name", with: "First"
        fill_in "Last name", with: "Last"
        fill_in "Password", with: "testing"
        fill_in "Password confirmation", with: "testing"
        click_button "Sign Up"
      end

      current_path.should eq(root_path)
    end
  end
end
