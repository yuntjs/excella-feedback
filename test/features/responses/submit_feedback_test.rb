require 'test_helper'

class SubmitFeedbackTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    @presentation = create(:presentation)
    create(:participation,
      user_id: @user.id,
      presentation_id: @presentation.id
    )

    @survey = create(:survey, presentation_id: @presentation.id)
    create_list(:question, 5, :number, survey_id: @survey.id)
    create_list(:question, 5, :text, survey_id: @survey.id)

    login_as(@user, scope: :user)

    visit new_presentation_response_path(@presentation)
  end

  after do
    Warden.test_reset!
  end

  feature 'submitting feedback' do
    scenario 'records responses if feedback submission is valid' do
      save_and_open_page
    end
  end
end
