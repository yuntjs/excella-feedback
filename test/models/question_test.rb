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

  describe '.build_from_templates' do
    let(:survey_template) { create(:survey_template) }

    it 'creates questions from a set of question templates' do
      question_count = 5
      question_templates = create_list(:question_template, question_count, :number, :required, survey_template_id: survey_template.id)

      questions = Question.build_from_templates(survey: survey, question_templates: question_templates)

      assert_equal questions.length, question_count, "Expected to build #{question_count} questions"
    end
  end

  describe '.valid_collection?' do
  end

  describe '.save_collection' do
  end
end
