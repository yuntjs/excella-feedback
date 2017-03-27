require 'test_helper'

class CreateQuestionTemplateTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  feature 'updating question templates for a survey' do
    let(:survey_template) { create(:survey_template) }
    let(:question_template) { create(:question_template, :text, :optional, survey_template_id: survey_template.id) }

    before do
      admin = create(:user, :admin)
      login_as(admin, scope: :user)

      visit(edit_survey_template_question_template_path(survey_template, question_template))
    end

    scenario 'question template form is valid' do
      fill_in('Prompt', with: 'prompt')
      select('Text')
      choose('question_template_response_required_true')
      click_button('Submit')

      assert page.has_content?('Success!'), 'Expected page to have a flash message with the word "Success!"'
      assert_equal current_path, survey_template_path(survey_template), 'Expected current path to be survey template show page'
    end

    scenario 'question template form is invalid' do
      fill_in('Prompt', with: '')
      select('')
      # Response required is changed from default value
      click_button('Submit')

      assert page.has_content?('Warning!'), 'Expected page to have a flash message with the word "Warning!"'
      assert page.has_content?('Edit Question for'), 'Expected question template form to be rendered'
      assert page.has_content?('Prompt can\'t be blank'), 'Expected error message for blank prompt'
      assert page.has_content?('Response type can\'t be blank'), 'Expected error message for blank response type'
    end
  end
end
