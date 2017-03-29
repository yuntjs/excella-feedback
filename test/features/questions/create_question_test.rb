require 'test_helper'

class CreateQuestionTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Create' do
    before do
      @title = "Intro to Git"
      @location = "ATX"
      @description = "Lorem ipsum descriptum"
    end
    scenario 'admin can create a new presentation' do
      admin = create(:user, :admin)

      login_as(admin, scope: :user)

      visit new_presentation_path


      within('form') do
        fill_in 'Title', with: @title
        fill_in 'Location', with: @location
        fill_in 'Description', with: @description
        click_button 'Submit'
      end

      page.must_have_content 'Success'
      page.must_have_content @title
      page.must_have_content @location
      page.must_have_content @description
    end
  end

end
