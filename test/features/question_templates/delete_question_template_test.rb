require 'test_helper'

class DeleteQuestionTemplateTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  feature 'deleting question templates' do
    let(:survey_template) { create(:survey_template) }
    let(:question_template) { create(:question_template, :text, :optional, survey_template_id: survey_template.id) }

    before do
      admin = create(:user, :admin)
      login_as(admin, scope: :user)

      question_template

      visit(survey_template_path(survey_template))
    end

    scenario 'delete button is selected' do
      within('table') do
        click_on('Delete')
      end

      assert page.has_content?('Success!'), 'Expected page to have a flash message with the word "Success!"'
      refute page.has_content?(question_template.prompt), 'Expected page to not display the deleted question\'s prompt'
      assert_equal current_path, survey_template_path(survey_template), 'Expected current path to be survey template show page'
    end
  end
end
