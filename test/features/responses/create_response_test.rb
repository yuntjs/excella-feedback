require 'test_helper'

class CreateResponseTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Create' do
    scenario 'creates a new response' do
      admin = create(:user, :admin)
      login_as(admin, scope: :user)
      pres = create(:presentation, title: 'Intro to Git')
      survey = create(:survey, presentation_id: pres.id)
      visit presentation_path(pres)

      click_on 'Provide Feedback'

      within ('form') do
        find('.form-control')
        fill_in 'The presentation was great', :with => 'No Additional comments'
        click_button 'Submit'
      end
    end
  end
end
