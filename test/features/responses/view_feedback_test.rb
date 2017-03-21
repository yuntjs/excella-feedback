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

    scenario 'average response value is shown for scale (number) responses' do
      number_question_ids = Question.where(response_type: 'number').pluck(:id)

      @controller = ResponsesController.new
      @controller.send(:build_chart_data, @presentation)

      number_question_ids.each do |question_id|
        assert_equal(@controller.instance_variable_get(:@average)[question_id], 3,
                     'Average was not calculated properly')
        assert page.has_content?('Average: 3'),
               'Average was not rendered properly'
      end
    end

    scenario 'presenter can see feedback for surveys about themselves' do
      presenter_survey = create(:survey, presentation_id: @presentation.id, presenter_id: @user.id)
      
      create_list(:question, 1, :text, :required, survey_id: presenter_survey.id) do |question|
        create(:response, value: 'Response for presenter only', question_id: question.id, user_id: @user.id)
      end
      
      visit presentation_responses_path(@presentation)

      assert page.has_content?('Response for presenter only')
    end

    scenario 'presenter cannot see feedback for surveys about another presenter' do
      another_user = create(:user)
      presenter_survey = create(:survey, presentation_id: @presentation.id, presenter_id: another_user.id)
      
      create_list(:question, 1, :text, :required, survey_id: presenter_survey.id) do |question|
        create(:response, value: 'Response for presenter only', question_id: question.id, user_id: @user.id)
      end
      
      visit presentation_responses_path(@presentation)
      
      refute page.has_content?('Response for presenter only')
    end

    scenario 'admin can see feedback for all surveys' do
      admin = create(:user, :admin)
      another_user = create(:user)
      presenter_survey = create(:survey, presentation_id: @presentation.id, presenter_id: another_user.id)
      
      create_list(:question, 1, :text, :required, survey_id: presenter_survey.id) do |question|
        create(:response, value: 'Response for presenter only', question_id: question.id, user_id: @user.id)
      end
      
      login_as(admin)
      
      visit presentation_responses_path(@presentation)
      
      assert page.has_content?('Response for presenter only')
    end
  end
end
