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

  describe '#new_survey_template_link' do
    it 'shows new actions for survey templates' do
      link_string = new_survey_template_link

      assert link_string.include?('New'), 'Link does not include "New"'
      assert link_string.include?(new_survey_template_path), 'Link does not include correct path'
    end
  end
end
