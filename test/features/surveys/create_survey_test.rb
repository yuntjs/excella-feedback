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

    scenario "cannot access survey#create if non-admin" do
      user = create(:user)
      login_as(user, scope: :user)

      pres = create(:presentation, title: "Intro to Git")

      visit new_presentation_survey_path(pres)

      refute_equal current_path, new_presentation_survey_path(pres), "Page did not redirect for non-admin"
    end

    scenario "does not create survey with empty subject" do
      admin = create(:user, :admin)
      login_as(admin, scope: :user)

      pres = create(:presentation, title: "Intro to Git")

      visit presentation_surveys_path(pres)

      click_on "Create New Survey"

      within ("form") do
        fill_in "Position", with: 1
        click_button "Submit"
      end

      page.must_have_content "Warning!"
    end
  end
end
