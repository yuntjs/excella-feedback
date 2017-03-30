require 'test_helper'

class DeleteQuestionTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Delete' do
    scenario 'an admin can delete a question' do
      admin = create(:user, :admin)
      presentation = create(:presentation, :in_the_future)
      survey = create(:survey, presentation_id: presentation.id)
      question = create(:question, :text, :optional, survey_id: survey.id)

      login_as(admin, scope: :user)

      visit presentation_survey_path(presentation, survey)

      click_on 'Delete'

      refute(page.has_content?(question.prompt))
      refute(page.has_content?(question.response_type))
    end

    scenario 'a presenter can delete a question'
  end
end
