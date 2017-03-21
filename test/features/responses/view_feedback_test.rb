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
  end

  feature 'viewing feedback as admin' do
    before do
      @admin = create(:user, :admin)
      @presentation_with_presenters = create(:presentation)
      @presenter1 = create(:user,
                          first_name: 'Burton',
                          last_name: 'White')
      @presenter2 = create(:user,
                          first_name: 'Steve',
                          last_name: 'Cooper')
      create(:participation, :presenter,
             user_id: @presenter1.id,
             presentation_id: @presentation_with_presenters.id
             )
      create(:participation, :presenter,
            user_id: @presenter2.id,
            presentation_id: @presentation_with_presenters.id
            )
      @survey1 = create(:survey,
                        presentation_id: @presentation_with_presenters.id,
                        presenter_id: @presenter1.id,
                        subject: "#{@presenter1.first_name} #{@presenter1.last_name}")
      create_list(:question, 2, :number, :required, survey_id: @survey1.id) do |question|
        create(:response, :number, question_id: question.id, user_id: @user.id)
      end
      create_list(:question, 2, :text, :required, survey_id: @survey1.id) do |question|
        create(:response, :text, question_id: question.id, user_id: @user.id)
      end
      @survey2 = create(:survey,
                        presentation_id: @presentation_with_presenters.id,
                        presenter_id: @presenter2.id,
                        subject: "#{@presenter2.first_name} #{@presenter2.last_name}")
      create_list(:question, 2, :number, :required, survey_id: @survey2.id) do |question|
        create(:response, :number, question_id: question.id, user_id: @user.id)
      end
      create_list(:question, 2, :text, :required, survey_id: @survey2.id) do |question|
        create(:response, :text, question_id: question.id, user_id: @user.id)
      end

    end
    
    scenario 'admin user can see feedback for all presenters' do
      login_as(@admin, scope: :user)

      visit presentation_responses_path(@presentation_with_presenters)

      assert page.has_content?("#{@presenter1.first_name} #{@presenter1.last_name}") && page.has_content?("#{@presenter2.first_name} #{@presenter2.last_name}"), "Admin unable to see both presenters."
    end
  end
end
