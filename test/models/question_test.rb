#
# Question model test
#
require 'test_helper'

describe Question do
  let(:survey) { create(:survey) }

  describe '.highest_position' do
    it 'returns the highest question position for a given survey' do
      question_count = 5
      create_list(:question, question_count, :number, :required, survey_id: survey.id)

      highest_position = Question.highest_position(survey)

      assert_equal highest_position, question_count, 'Expected the highest question position to equal the question count'
    end

    it 'returns zero if a survey has no questions' do
      highest_position = Question.highest_position(survey)

      assert_equal highest_position, 0, 'Expected the highest question position to equal zero'
    end
  end

  describe '.create_from_templates' do
    let(:survey_template) { create(:survey_template) }

    it 'creates questions from a set of question templates' do
      question_count = 5
      question_templates = create_list(:question_template, question_count, :number, :required, survey_template_id: survey_template.id)

      questions = Question.create_from_templates(survey: survey, question_templates: question_templates)

      assert_equal question_count, Question.count, "Expected to create #{question_count} questions"
      question_count.times do |q|
        assert_equal questions[q].prompt, question_templates[q].prompt, 'Expected question prompt to match question template prompt'
        assert_equal questions[q].response_type, question_templates[q].response_type, 'Expected question response type to match question template response type'
        assert_equal questions[q].response_required, question_templates[q].response_required, 'Expected question response required to match question template response required'
        assert questions[q].position.present?
      end
    end
  end
end
