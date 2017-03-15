require 'test_helper'
include FactoryGirl::Syntax::Methods

class SubmitFeedbackTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    @presentation = create(:presentation)
    create(:participation,
      user_id: @user.id,
      presentation_id: @presentation.id
    )

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
    scenario 'feedback submission is valid' do
      Question.all.each do |question|
        case question.response_type
        when 'number'
          choose("responses_question_id_#{question.id}_3")
        when 'text'
          fill_in("responses_question_id_#{question.id}", with: "Text")
        else
        end
      end

      click_on('Submit')

      assert page.has_content?('Success!'),
        'Page does not have success flash message'
      assert_equal Response.count, Question.count,
        'The correct amount of responses were not created'
      assert_equal current_path, presentation_path(@presentation),
        "Current path does not match desired path"
    end

    scenario 'feedback submission is invalid' do
      question = Question.first

      case question.response_type
      when 'number'
        choose("responses_question_id_#{question.id}_3")
      when 'text'
        fill_in("responses_question_id_#{question.id}", with: "Text")
      else
      end

      click_on('Submit')

      assert page.has_content?('Warning!'),
        'Page does not have error flash message'
      assert_equal Response.count, 0,
        'Response were saved after an invalid submission'
      assert_equal current_path, presentation_responses_path(@presentation),
        "Current path does not match desired path"
      # TODO: should desired path be new_presentation_response_path instead?
    end
  end
end
