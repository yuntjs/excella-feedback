require 'test_helper'

class DestroySurveyTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Destroy' do
    scenario 'clicking "Delete Survey" as admin deletes the survey' do
      admin = create(:user, :admin)
      presentation = create(:presentation)
      survey = create(:survey, presentation_id: presentation.id)

      login_as(admin, scope: :user)

      visit presentation_surveys_path(presentation)

      click_on 'Delete Survey'

      refute(page.has_content?(survey.title))
    end

    scenario 'clicking "Delete Survey" as presenter deletes the survey' do
      presenter = create(:user)
      presentation = create(:presentation)
      create(:participation, :presenter,
             user_id: presenter.id,
             presentation_id: presentation.id)
      survey = create(:survey, presentation_id: presentation.id)

      login_as(presenter, scope: :user)

      visit presentation_surveys_path(presentation)

      click_on 'Delete Survey'

      refute(page.has_content?(survey.title))
    end
  end

end
