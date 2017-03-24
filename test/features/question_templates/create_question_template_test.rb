require 'test_helper'

class CreateQuestionTemplateTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  feature 'creating question templates for a survey' do
    let(:survey_template) { create(:survey_template) }

    before do
      admin = create(:user, :admin)
      login_as(admin, scope: :user)

      visit(new_survey_template_question_template_path(survey_template))
    end

    scenario 'creates a question template if inputs are valid' do
      fill_in('Prompt', with: 'prompt')
      click_button('Submit')
    end
  end
end
