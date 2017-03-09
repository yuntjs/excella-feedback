require "test_helper"

class CreateSurveyTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature "Create" do
    scenario "creates a new survey if admin" do
      admin = create(:user, :admin)
      login_as(admin, scope: :user)

      pres = create(:presentation, title: "Intro to Git")

      visit presentation_surveys_path(pres)

      click_on "Create New Survey"

      within ("form") do
        fill_in "Position", with: 1
        fill_in "Subject", with: "Testing"
        click_button "Submit"
      end

      page.must_have_content "Testing"

    end
  end


end
