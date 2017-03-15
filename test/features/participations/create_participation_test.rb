require 'test_helper'
require 'capybara/rails'

class CreateParticipationTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Create' do
    scenario 'creates a new participation if admin' do
      user = create :user, :admin
      pres = create(:presentation, title: "user's presentation")
      login_as(user, scope: :user)

      visit presentation_path(pres)
      within('#participation-form-modal') do
        page.check user.full_name
      end

      find('#submit-capybara', visible: false).click

      within('.attendees') do
        page.must_have_content user.email
      end
    end

    scenario 'unable to create a new participation if non-admin' do
      user = create :user
      pres = create(:presentation, title: "user's presentation")
      login_as(user, scope: :user)

      visit presentation_path(pres)

      refute page.has_content? 'Edit Participants'
    end
  end
end
