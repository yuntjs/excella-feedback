#
# Question model test
#
require 'test_helper'

describe Question do
  let(:survey) { create(:survey) }

  describe '.normalize_position' do
    it 'sets survey positions so they are in sequential order' do
      create(:question, :number, :required, position: 1, survey_id: survey.id)
      create(:question, :number, :required, position: 5, survey_id: survey.id)
      create(:question, :number, :required, position: 10, survey_id: survey.id)
      create(:question, :number, :required, position: 2, survey_id: survey.id)
      create(:question, :number, :required, position: 4, survey_id: survey.id)

      Question.normalize_position(survey)

      positions = Question.all..order(:position).pluck(:position)

      assert_equal [1, 2, 3, 4, 5], positions, 'Expected question positions to be in sequential order'
    end
  end

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

      questions = Question.build_from_templates(question_templates)

      question_count.times do |q|
        assert questions[q].new_record?, 'Expected unsaved question to be a new record'
        assert_equal questions[q].prompt, question_templates[q].prompt, 'Expected question prompt to match question template prompt'
        assert_equal questions[q].response_type, question_templates[q].response_type, 'Expected question response type to match question template response type'
        assert_equal questions[q].response_required, question_templates[q].response_required, 'Expected question response required to match question template response required'
        assert questions[q].position.present?
      end
    end
  end
end
