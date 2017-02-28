require "test_helper"

class CreateParticipationTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature "Create" do
    scenario "creates a new participation if admin" do
      u = create :user, :admin
      pres = create(:presentation, title: "user's presentation")
      login_as(u, scope: :user)
      # Must refresh page for login_as to take effect
      visit presentation_path(pres)
      click_on "Edit Participants"
      page.check u.email
      click_button "Submit Changes"
      # Check for User listing
      page.must_have_content u.email
    end

    scenario "creates a new participation if admin" do
      u = create :user
      pres = create(:presentation, title: "user's presentation")
      login_as(u, scope: :user)
      # Must refresh page for login_as to take effect
      visit presentation_path(pres)
      # Check for "Edit Participants" button
      refute page.has_content? "Edit Participants"
    end

  end
end
