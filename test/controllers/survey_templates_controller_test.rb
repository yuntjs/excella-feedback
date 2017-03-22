require 'test_helper'

class SurveyTemplatesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  describe '#index' do
    it 'gets all survey_templates if you are an admin' do
      admin = create :user, :admin
      survey_template = create :survey_template
      sign_in(admin)

      get(:index)

      assert_equal(SurveyTemplate.all, [survey_template], 'Did not return survey_templates')
    end
  end
end
