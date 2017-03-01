require "test_helper"

class CreateParticipationTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature "Destroy" do
    scenario "destroys a participation if admin" do
      u = create :user, :admin
      pres = create(:presentation, title: "user's presentation")
      create(:participation, user: u, presentation: pres)
      login_as(u, scope: :user)
      # Must refresh page for login_as to take effect
      visit presentation_path(pres)

      within "#participation-form-modal" do
        page.uncheck u.email
      end

      find("#submit-capybara", visible: false).click

      within "ol" do
        refute page.has_content? u.email
      end
    end

    scenario "unable to destroy a participation if non-admin" do
      u = create :user
      pres = create(:presentation, title: "user's presentation")
      create(:participation, user: u, presentation: pres)
      login_as(u, scope: :user)
      # Must refresh page for login_as to take effect
      visit presentation_path(pres)
      # Check for "Edit Participants" button
      refute page.has_content? "Edit Participants"
    end

  end
end
