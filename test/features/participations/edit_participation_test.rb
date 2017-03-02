require "test_helper"
require "capybara/rails"

class EditParticipationTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature "Edit" do
    scenario "sets attendee to presenter" do
      admin = create :user, :admin
      pres = create(:presentation, title: "user's presentation")
      part = create(:participation, user: admin, presentation: pres, is_presenter: false)
      login_as(admin, scope: :user)
      # Must refresh page for login_as to take effect
      visit presentation_path(pres)

      within ".attendees" do
        click_on "Add Presenter"
      end

      within ".presenters" do
        page.must_have_content admin.email
      end
    end

    scenario "sets presenter to attendee" do
      admin = create :user, :admin
      pres = create(:presentation, title: "user's presentation")
      part = create(:participation, user: admin, presentation: pres, is_presenter: true)
      login_as(admin, scope: :user)
      # Must refresh page for login_as to take effect
      visit presentation_path(pres)

      within ".presenters" do
        click_on "Remove Presenter"
      end

      within ".presenters" do
        refute page.has_content? admin.email
      end
    end

  end
end
