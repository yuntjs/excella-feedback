require 'test_helper'

class EditSurveyTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Edit' do
    scenario 'updates survey data with new data when admin' do
      admin = create(:user, :admin)
      presentation = create(:presentation, title: 'Intro to Git')
      create(:survey, presentation_id: presentation.id)

      login_as(admin, scope: :user)

      visit presentation_surveys_path(presentation)

      click_on 'Edit Survey'

      new_title = 'New Title'

      within('form') do
        fill_in 'Position', with: 1
        fill_in 'Title', with: new_title
        click_button 'Submit'
      end

      assert(page.has_content?(new_title))
    end

    scenario 'updates survey data with new data when presenter' do
      presenter = create(:user)
      presentation = create(:presentation, title: 'Intro to Git')
      create(:participation, :presenter,
             user_id: presenter.id,
             presentation_id: presentation.id)
      create(:survey, presentation_id: presentation.id)

      login_as(presenter, scope: :user)

      visit presentation_surveys_path(presentation)

      click_on 'Edit Survey'

      new_title = 'New Title'

      within('form') do
        fill_in 'Position', with: 1
        fill_in 'Title', with: new_title
        click_button 'Submit'
      end

      assert(page.has_content?(new_title))
    end

    scenario 'a presenter cannot edit another presenters survey' do
      presenter1 = create(:user)
      presenter2 = create(:user)

      presentation = create(:presentation)

      create(:participation, :presenter,
             user_id: presenter1.id,
             presentation_id: presentation.id)
      create(:participation, :presenter,
             user_id: presenter2.id,
             presentation_id: presentation.id)

      survey = create(:survey,
                      presentation_id: presentation.id,
                      presenter_id: presenter2.id)

      login_as(presenter1, scope: :user)

      visit presentation_surveys_path(presentation)

      button = find_link('Edit Survey')

      assert(button[:class].include?("disabled"))
    end
  end
end
