require 'test_helper'

class ViewFeedbackTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @admin = create(:user, :admin)
    @user = create(:user)
    @presenter1 = create(:user,
                         first_name: 'Burton',
                         last_name: 'White')
    @presenter2 = create(:user,
                         first_name: 'Steve',
                         last_name: 'Cooper')
    @presentation = create(:presentation)
    create(:participation, :presenter,
           user_id: @presenter1.id,
           presentation_id: @presentation.id)
    create(:participation, :presenter,
           user_id: @presenter2.id,
           presentation_id: @presentation.id)
    @survey1 = create(:survey,
                      presentation_id: @presentation.id,
                      presenter_id: @presenter1.id,
                      subject: "#{@presenter1.first_name} #{@presenter1.last_name}")
    create_list(:question, 2, :number, :required, survey_id: @survey1.id) do |question|
      create(:response, :number, question_id: question.id, user_id: @user.id)
    end
    create_list(:question, 2, :text, :required, survey_id: @survey1.id) do |question|
      create(:response, value: "Response for #{@presenter1.first_name} #{@presenter1.last_name}", question_id: question.id, user_id: @user.id)
    end
    @survey2 = create(:survey,
                      presentation_id: @presentation.id,
                      presenter_id: @presenter2.id,
                      subject: "#{@presenter2.first_name} #{@presenter2.last_name}")
    create_list(:question, 2, :number, :required, survey_id: @survey2.id) do |question|
      create(:response, :number, question_id: question.id, user_id: @user.id)
    end
    create_list(:question, 2, :text, :required, survey_id: @survey2.id) do |question|
      create(:response, value: "Response for #{@presenter2.first_name} #{@presenter2.last_name}", question_id: question.id, user_id: @user.id)
    end
  end

  after do
    Warden.test_reset!
  end

  feature 'viewing feedback as admin' do
    before do
      login_as(@admin, scope: :user)

      visit presentation_responses_path(@presentation)
    end

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

    scenario 'admin user can see feedback for all presenters' do
      assert page.has_content?("#{@presenter1.first_name} #{@presenter1.last_name}"), 'Admin unable to see first presenter'
      assert page.has_content?("#{@presenter2.first_name} #{@presenter2.last_name}"), 'Admin unable to see second presenter.'
    end
  end

  feature 'viewing feedback as presenter' do
    before do
      login_as(@presenter1, scope: :user)

      visit presentation_responses_path(@presentation)
    end

    scenario 'presenter can see feedback for surveys only about themselves' do
      visit presentation_responses_path(@presentation)

      assert page.has_content?("Response for #{@presenter1.first_name} #{@presenter1.last_name}")
      refute page.has_content?("Response for #{@presenter2.first_name} #{@presenter2.last_name}")
    end
  end
end
