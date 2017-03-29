require 'test_helper'

class CreateSurveyTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Create' do
    scenario 'creates a new survey if admin' do
      admin = create(:user, :admin)
      presentation = create(:presentation, title: 'Intro to Git')

      login_as(admin, scope: :user)

      visit presentation_surveys_path(presentation)

      click_on 'Create New Survey'

      within('form') do
        fill_in 'Position', with: 1
        fill_in 'Title', with: 'Testing'
        click_button 'Submit'
      end

      page.must_have_content 'Testing'
    end

    scenario 'creates a new survey if user is presenter for the presentation' do
      presenter = create(:user)
      presentation = create(:presentation)
      create(:participation, :presenter,
             user_id: presenter.id,
             presentation_id: presentation.id)

      login_as(presenter, scope: :user)

      visit presentation_surveys_path(presentation)
      click_on 'Create New Survey'

      title = 'Testing'

      within('form') do
        fill_in 'Position', with: 1
        fill_in 'Title', with: title
        click_button 'Submit'
      end

      page.must_have_content title
    end

    scenario 'cannot access survey#create if non-admin' do
      user = create(:user)
      login_as(user, scope: :user)

      pres = create(:presentation, title: 'Intro to Git')

      visit new_presentation_survey_path(pres)

      refute_equal current_path, new_presentation_survey_path(pres), 'Page did not redirect for non-admin'
    end

    scenario 'does not create survey with empty title' do
      admin = create(:user, :admin)
      login_as(admin, scope: :user)

      presentation = create(:presentation, title: 'Intro to Git')

      visit presentation_surveys_path(presentation)

      click_on('Create New Survey')

      within('form') do
        fill_in 'Position', with: 1
        click_button 'Submit'
      end

      page.must_have_content('Warning!')
    end
  end
end
