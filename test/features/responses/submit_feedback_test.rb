require 'test_helper'

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
    scenario 'records responses if feedback submission is valid' do
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

      assert page.has_content?('Success! Your responses have beeen successfully recorded.'),
        'Page does not have success flash message'
      assert_equal Response.count, Question.count,
        'The correct amount of responses were not created'
      assert_equal current_path, presentation_path(@presentation),
        "Current path does not match desired path"
    end
  end
end
