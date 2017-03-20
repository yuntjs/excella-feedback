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
      else
      end
    end
  end

  describe '#set_responses' do
    it 'creates unsaved responses when given form input values' do
      @feedback.set_responses(form_input: @form_input)

      @feedback.survey_data.each do |survey|
        assert survey[:responses].first.new_record?,
          'The newly-created response object is not a new record'
        assert_equal survey[:responses].count, survey[:questions].count,
          'The number of unsaved responses does not match the number of questions'
        assert_equal survey[:responses][0].value, @test_num,
          'The value was not set for a numerical response'
        assert_equal survey[:responses][1].value, @test_text,
          'The value was not set for a textual response'
      end
    end

    it 'creates unsaved responses even without form input values' do
      @feedback.set_responses

      @feedback.survey_data.each do |survey|
        assert survey[:responses].first.new_record?,
          'The newly-created response object is not a new record'
        assert_equal survey[:responses].count, survey[:questions].count,
          'The number of unsaved responses does not match the number of questions'
        assert_nil survey[:responses][0].value, 'Response values are not nil'
      end
    end
  end

  describe '#valid?' do
    it 'returns true if all response objects are valid' do
      @feedback.set_responses(form_input: @form_input)

      assert @feedback.valid?, 'Expected invalid feedback to be valid'
    end

    it 'returns false if any response object is invalid' do
      @feedback.set_responses # without @form_input, all response values are nil

      refute @feedback.valid?, 'Expected valid feedback to be invalid'
    end
  end

  describe '#save' do
    it 'saves all responses in feedback object' do
      @feedback.set_responses(form_input: @form_input)

      @feedback.save

      assert Response.count > 0, 'Expect Response.count to be greater than 0'
    end
  end
end
