require 'test_helper'

class SubmitFeedbackTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    @presentation = create(:presentation)
    create(:participation,
           user_id: @user.id,
           presentation_id: @presentation.id)

    @survey = create(:survey, presentation_id: @presentation.id)
    create_list(:question, 5, :number, :required, survey_id: @survey.id)
    create_list(:question, 5, :text, :required, survey_id: @survey.id)

    login_as(@user, scope: :user)

    visit new_presentation_response_path(@presentation)
  end

  after do
    Warden.test_reset!
  end

  feature 'submitting feedback' do
    scenario 'feedback submission is valid if all required questions are answered' do
      Question.all.each do |question|
        case question.response_type
        when 'number'
          choose("responses_question_id_#{question.id}_3")
        when 'text'
          fill_in("responses_question_id_#{question.id}", with: 'Text')
        end
      end

      click_on('Submit')

      assert page.has_content?('Success!'),
             'Page does not have a success flash message'
      assert_equal Response.count, Question.count,
                   'The correct amount of responses were not created'
      assert_equal current_path, presentation_path(@presentation),
                   'The current path does not match the desired path'
    end

    scenario 'feedback submission is invalid if any required question are unanswered' do
      question = Question.first

      case question.response_type
      when 'number'
        choose("responses_question_id_#{question.id}_3")
      when 'text'
        fill_in("responses_question_id_#{question.id}", with: 'Text')
      end

      click_on('Submit')

      assert page.has_content?('Warning!'),
             'Page does not have an error flash message'
      assert page.has_content?('Required question - please provide a response.', count: Question.count - 1),
             'Page does not display the correct number of error messages for invalid question responses'
      assert page.has_css?('.has-error'),
             'Page does not have the "has-error" class for displaying errors'
      assert_equal Response.count, 0,
                   'Responses were saved after an invalid submission'
      assert_equal current_path, presentation_responses_path(@presentation),
                   'The current path does not match the desired path'
      # TODO: should desired path be new_presentation_response_path instead?
    end
  end
end
