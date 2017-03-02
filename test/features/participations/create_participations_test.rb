require "test_helper"
require "capybara/rails"

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

      within "#participation-form-modal" do
        page.check u.email
      end

      find("#submit-capybara", visible: false).click

      within ".attendees" do
        page.must_have_content u.email
      end
    end

    scenario "unable to create a new participation if non-admin" do
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
