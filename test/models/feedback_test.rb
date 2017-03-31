#
# Feedback PORO test
#
require 'test_helper'

describe Feedback do
  before do
    @user = create(:user)
    presentation = create(:presentation)
    surveys = create_list(:survey, 3, presentation_id: presentation.id)

    surveys.each do |survey|
      create(:question, :number, :required, survey_id: survey.id)
      create(:question, :text, :required, survey_id: survey.id)
    end

    @feedback = Feedback.new(@user, surveys)

    @test_num = '3'
    @test_text = 'Text'

    @form_input = {}

    Question.all.each do |question|
      case question.response_type
      when 'number'
        @form_input[question.id.to_s] = @test_num
      when 'text'
        @form_input[question.id.to_s] = @test_text
      end
    end
  end

  describe '#add_responses' do
    it 'creates unsaved responses when given form input values' do
      @feedback.add_responses(form_input: @form_input)

      @feedback.data.each do |data|
        assert data[:survey_responses].first.new_record?, 'The newly-created response object is not a new record'
        assert_equal data[:survey_responses].count, data[:survey_questions].count, 'The number of unsaved responses does not match the number of questions'
        assert_includes [data[:survey_responses][0].value, data[:survey_responses][1].value], @test_num, 'The value was not set for a numerical response'
        assert_includes [data[:survey_responses][0].value, data[:survey_responses][1].value], @test_text, 'The value was not set for a textual response'
      end
    end

    it 'creates unsaved responses even without form input values' do
      @feedback.add_responses

      @feedback.data.each do |data|
        assert data[:survey_responses].first.new_record?, 'The newly-created response objects are not new records'
        assert_equal data[:survey_responses].count, data[:survey_questions].count, 'The number of unsaved responses does not match the number of questions'
        assert_nil data[:survey_responses][0].value, 'Response values are not nil'
      end
    end
  end

  describe '#valid?' do
    it 'returns true if all response objects are valid' do
      @feedback.add_responses(form_input: @form_input)

      assert @feedback.valid?, 'Expected invalid feedback to be valid'
    end

    it 'returns false if any response object is invalid' do
      @feedback.add_responses # without @form_input, all response values are nil

      refute @feedback.valid?, 'Expected valid feedback to be invalid'
    end
  end

  describe '#save' do
    it 'saves all responses in feedback object' do
      @feedback.add_responses(form_input: @form_input)

      @feedback.save

      assert Response.count.positive?, 'Expected number of responses to be greater than 0'
    end
  end
end
