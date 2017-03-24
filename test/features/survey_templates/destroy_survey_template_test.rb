require 'test_helper'

class DestroySurveyTemplateTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Destroy' do
    before do
      admin = create :user, :admin
      @survey_template = create(:survey_template)

      login_as(admin, scope: :user)

      visit(survey_template_path(@survey_template))
    end

    scenario 'clicking "Delete Survey" deletes survey_template' do
      click_on('Delete Survey')

      refute(page.has_content?(@survey_template.name))
      refute(page.has_content?(@survey_template.title))
    end
  end
end
