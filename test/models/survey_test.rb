#
# Survey model test
#
require 'test_helper'

describe Survey do
  let(:presentation) { create(:presentation) }

  describe '.highest_position' do
    it 'returns the highest survey position for a given presentation' do
      survey_count = 5
      create_list(:survey, survey_count, presentation_id: presentation.id)

      highest_position = Survey.highest_position(presentation)

      assert_equal highest_position, survey_count, 'Expected the highest survey position to equal the survey count'
    end

    it 'returns zero if a presentation has no surveys' do
      highest_position = Survey.highest_position(presentation)

      assert_equal highest_position, 0, 'Expected the highest survey position to equal zero'
    end
  end

  describe '.create_from_template' do
    let(:survey_template) { create(:survey_template) }

    it 'creates survey from a survey_template' do
      survey_template = create(:survey_template)

      survey = Survey.create_from_template(presentation: presentation, survey_template: survey_template)

      assert_equal Survey.count, 1, "Expected to create a survey from the survey template"
      assert_equal survey.title, survey_template.title, 'Expected survey title to match survey template title'
    end
  end
end
