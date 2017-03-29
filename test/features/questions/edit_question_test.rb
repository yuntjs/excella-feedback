require 'test_helper'

class EditQuestionTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Edit' do
    before do
      @prompt = 'Was this presentation excellent?'
      @response_type = 'Number'
      @response_required = 'question_response_required_true'
    end

    scenario 'admin can edit a question' do
      admin = create(:user, :admin)
      presentation = create(:presentation, :in_the_future)
      survey = create(:survey, presentation_id: presentation.id)
      create(:question, :text, :optional, survey_id: survey.id)

      login_as(admin, scope: :user)

      visit presentation_survey_path(presentation, survey)

      click_on 'Edit'

      within('form') do
        fill_in 'Prompt', with: @prompt
        select(@response_type, from: 'question_response_type')
        choose(@response_required)
        click_button 'Submit'
      end

      page.must_have_content 'Success'
      page.must_have_content @prompt
      page.must_have_content @response_type
      page.must_have_content '✓'
    end
  end
end
