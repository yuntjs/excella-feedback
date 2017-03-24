require 'test_helper'

class ViewFeedbackTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  feature 'viewing Survey Templates as admin' do
    before do
      admin = create :user, :admin
      login_as(admin, scope: :user)

      visit(root_path)
    end

    scenario 'clicking Survey Templates button in navbar navigates to SurveyTemplate#index' do
      within('.navbar-right') do
        click_on('Survey Templates')
      end

      assert_equal(current_path, survey_templates_path, 'Did not route to survey_templates_path')
    end
  end
end
