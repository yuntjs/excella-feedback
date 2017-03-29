require 'test_helper'

class CreateSurveyTest < Capybara::Rails::TestCase
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
  end

end
