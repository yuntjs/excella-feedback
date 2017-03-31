require 'test_helper'

class CreateSurveyFromTemplateTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'creating a survey from a survey template' do
    before do
      admin = create :user, :admin
      login_as admin, scope: :user

      @presentation = create :presentation

      create_list :survey, 5, presentation_id: @presentation.id

      @survey_template = create :survey_template
      create :question_template, :number, :required, survey_template_id: @survey_template.id

      visit presentation_surveys_path(@presentation)
    end

    scenario 'selecting a survey template to add' do
      within '#survey-presentations' do
        refute page.has_content?(@survey_template.title)
      end

      click_link 'Add to Presentation'

      within '#survey-presentations' do
        assert page.has_content?(@survey_template.title)
      end
    end
  end
end
