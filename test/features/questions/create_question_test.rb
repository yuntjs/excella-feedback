require 'test_helper'

class CreateQuestionTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Create' do
    let(:prompt) { 'Was this presentation excellent?' }
    let(:response_type) { 'Number' }
    let(:response_required) { 'question_response_required_true' }  

    scenario 'admin can create a new question for a survey' do
      admin = create(:user, :admin)
      presentation = create(:presentation, :in_the_future)
      survey = create(:survey, presentation_id: presentation.id)

      login_as(admin, scope: :user)

      visit new_presentation_survey_question_path(presentation, survey)

      within('form') do
        fill_in 'Prompt', with: prompt
        select(response_type, from: 'question_response_type')
        choose(response_required)
        click_button 'Submit'
      end

      page.must_have_content 'Success'
      page.must_have_content prompt
      page.must_have_content response_type
      page.must_have_content '✓'
    end

    scenario 'presenter can create a new question for a survey' do
      presenter = create(:user)
      presentation = create(:presentation, :in_the_future)
      survey = create(:survey, presentation_id: presentation.id)
      create(:participation, :presenter,
             user_id: presenter.id,
             presentation_id: presentation.id)

      login_as(presenter, scope: :user)

      visit new_presentation_survey_question_path(presentation, survey)

      within('form') do
        fill_in 'Prompt', with: prompt
        select(response_type, from: 'question_response_type')
        choose(response_required)
        click_button 'Submit'
      end

      page.must_have_content 'Success'
      page.must_have_content prompt
      page.must_have_content response_type
      page.must_have_content '✓'
    end
  end
end
