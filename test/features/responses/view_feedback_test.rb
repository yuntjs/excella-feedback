require 'test_helper'
include FactoryGirl::Syntax::Methods

class ViewFeedbackTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    @presentation = create(:presentation)
    create(:participation,
           user_id: @user.id,
           presentation_id: @presentation.id)

    @survey = create(:survey, presentation_id: @presentation.id)
    create_list(:question, 5, :number, :required, survey_id: @survey.id) do |question|
      create(:response, :number, question_id: question.id, user_id: @user.id)
    end
    create_list(:question, 5, :text, :required, survey_id: @survey.id) do |question|
      create(:response, :text, question_id: question.id, user_id: @user.id)
    end

    login_as(@user, scope: :user)

    visit presentation_responses_path(@presentation)
  end

  after do
    Warden.test_reset!
  end

  feature 'viewing feedback' do
    scenario 'feedback for scale (number) responses render properly as chart' do
      number_question_ids = Question.where(response_type: 'number').pluck(:id)

      number_question_ids.each do |question_id|
        assert_equal(Response.where(question_id: question_id, user_id: @user.id).first.value, '3',
        'Response data not properly saved for number responses')
      end
    end

    scenario 'feedback for text responses render as list of all entries' do
      text_question_ids = Question.where(response_type: 'text').pluck(:id)

      text_question_ids.each do |question_id|
        assert page.has_content?("Question #{question_id}"),
        'Page does not have proper prompts for text questions'

        assert page.has_content?(Response.where(question_id: question_id, user_id: @user.id).first.value),
        'Page does not have proper responses for text questions'
      end
    end
  end
end
