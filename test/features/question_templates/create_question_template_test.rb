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

    scenario 'question template form is valid' do
      fill_in('Prompt', with: 'prompt')
      select("Text")
      choose('question_template_response_required_true')
      click_button('Submit')

      assert page.has_content?('Success!')
      assert_equal QuestionTemplate.count, 1, 'Expected a question template to be created'
      assert_equal current_path, survey_template_path(survey_template), 'Expected current path to be survey template show page'
    end

    scenario 'question template form is invalid' do
      # No prompt input
      # Response type was not selected
      # Response required is not changed from default value
      click_button('Submit')

      assert page.has_content?('Warning!')
      assert_equal QuestionTemplate.count, 0, 'Did not expect a question template to be created'
      assert page.has_content?('New Question for'), 'Expected question template form to be rendered'
    end
  end
end
