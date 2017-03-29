require 'test_helper'

class CreateQuestionTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Create' do
    before do
      @prompt = 'Was this presentation excellent?'
      @response_type = 'number'
      @response_required = true
    end
    scenario 'admin can create a new question for a survey' do
      admin = create(:user, :admin)
      presentation = create(:presentation, :in_the_future)
      survey = create(:survey, presentation_id: presentation.id)

      login_as(admin, scope: :user)

      visit new_presentation_survey_question_path(presentation, survey)

      within('form') do
        fill_in 'Prompt', with: @prompt
        select(@response_type)
        # fill_in 'ResponseType', with: @response_type
        # fill_in 'Response Required', with: @response_required
        click_button 'Submit'
      end

      page.must_have_content 'Success'
      # page.must_have_content @title
      # page.must_have_content @location
      # page.must_have_content @description
    end
  end
end
