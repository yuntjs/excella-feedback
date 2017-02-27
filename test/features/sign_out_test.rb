require "test_helper"

class SignOutTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature "Sign Out" do
    scenario "visits sign out path" do
      u = create :user
      login_as(u, scope: :user)
      # Must refresh page for login_as to take effect
      visit root_path
      click_on "Log Out"
      # Check for "Log In" option in nav
      page.must_have_content "Log In"
    end
  end
end
