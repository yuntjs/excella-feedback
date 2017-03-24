require 'test_helper'

class SurveyTemplatesHelperTest < ActionView::TestCase
  describe '#action_buttons' do
    it 'shows edit and delete actions for survey templates' do
      survey_template = create(:survey_template)
      link_string = action_buttons(survey_template)

      assert link_string.include?('Edit'), 'Link does not include "Edit"'
      assert link_string.include?('Delete'), 'Link does not include "Delete"'
      assert link_string.include?(edit_survey_template_path(survey_template)), 'Link does not include correct path'
    end
  end

  describe '#required_check' do
    it 'checks if a questions_template is required and returns a formatted response' do
      question_required = create(:question_template, :text, :required)
      question_not_required = create(:question_template, :text, :optional)
      expected_required = "✓"
      expected_not_required = ""

      actual_required = required_check(question_required)
      actual_not_required = required_check(question_not_required)

      assert_equal expected_required, actual_required
      assert_equal expected_not_required, actual_not_required
    end
  end
end
