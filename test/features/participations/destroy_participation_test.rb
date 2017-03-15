require 'test_helper'

class CreateParticipationTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Destroy' do
    scenario 'destroys a participation if admin' do
      user = create :user, :admin
      pres = create(:presentation, title: "user's presentation")
      create(:participation,
             user_id: user.id,
             presentation_id: pres.id)

      login_as(user, scope: :user)

      visit presentation_path(pres)

      within '#participation-form-modal' do
        page.uncheck user.full_name
      end

      find('#submit-capybara', visible: false).click

      within '.attendees' do
        refute page.has_content? user.email
      end
    end

    scenario 'unable to destroy a participation if non-admin' do
      user = create :user
      pres = create(:presentation, title: "user's presentation")
      login_as(user, scope: :user)

      create(:participation,
             user_id: user.id,
             presentation_id: pres.id)

      visit presentation_path(pres)

      refute page.has_content? 'Edit Participants'
    end
  end
end
