require 'test_helper'

class ResponsesControllerTest < ActionController::TestCase
  # include FactoryGirl::Syntax::Methods
  include Devise::Test::ControllerHelpers

  before do
    @user = create :user
    @presentation = create :presentation
    @survey = create :survey, position: 1, subject: 'Git', presentation_id: @presentation.id
    @questions = create_list :question, 5, :required, :number, survey_id: @survey.id

    sign_in @user
  end

  describe '#new' do
    it 'creates multiple unsaved response objects from questions for the view' do
      get :new, params: { presentation_id: @presentation.id }
      feedback = assigns(:feedback)

      num_responses = 0
      feedback.survey_data.each do |survey|
        num_responses += survey[:responses].count
      end

      assert_equal @questions.length, num_responses, 'Did not create the correct number of unsaved responses'
    end
  end

  describe '#index' do
    it 'should show all responses' do
      pres = create(:presentation)
      survey = create(:survey, presentation_id: pres.id)
      question = create(:question, survey_id: survey.id)
      response1 = create(:response, question_id: question.id)

      assert_equal pres.surveys.first.questions.first.responses, [response1], 'Did not return any Responses'
    end
  end

  describe '#create' do
    it 'creates responses if they are valid' do
      create(:participation,
             user_id: @user.id,
             presentation_id: @presentation.id)

      question_value_pairs = {}
      @questions.each do |question|
        question_value_pairs[question.id.to_s] = '1'
      end

      post :create, params: {
        presentation_id: @presentation.id,
        responses: {
          question_id: question_value_pairs
        }
      }

      assert_equal @questions.length, Response.count, 'Did not create a response for each question'
      assert_redirected_to presentation_path(@presentation), 'No redirect to presentation_path'
    end

    it 'does not save any responses if any are invalid' do
      question_value_pairs = {}
      @questions.each do |question|
        question_value_pairs[question.id.to_s] = '1'
      end

      question_value_pairs[@questions.first.id.to_s] = ''
      question_value_pairs[@questions.last.id.to_s] = ''

      assert Response.all.empty?, 'Invalid responses created'
      # TODO: assert_template :new not working
    end
  end
end
