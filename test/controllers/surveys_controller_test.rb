require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create(:user, :admin)
    @presentation = create(:presentation)

    sign_in @admin
  end

  describe '#new' do
    before do
      get(:new, params: { presentation_id: @presentation.id })
    end
    it 'sets presentation as an instance variable' do
      presentation = assigns(:presentation)

      assert_equal @presentation, presentation, 'Expected presentation to be set as an instance variable'
    end

    it 'sets survey as a new instance variable' do
      survey = assigns(:survey)

      assert survey.new_record?, 'Expected survey to be a new record'
    end
  end

  describe '#show' do
    let(:survey) { create(:survey, presentation_id: @presentation.id) }

    before do
      get(:show, params: { presentation_id: @presentation.id, id: survey.id })
    end

    it 'sets presentation as an instance variable' do
      presentation = assigns(:presentation)

      assert_equal @presentation, presentation, 'Expected presentation to be set as an instance variable'
    end

    it 'sets survey as an instance variable' do
      assigned_survey = assigns(:survey)

      assert_equal survey, assigned_survey, 'Expected survey to be set as an instance variable'
    end
  end

  describe '#edit' do
    let(:survey) { create(:survey, presentation_id: @presentation.id) }

    before do
      get(:edit, params: { presentation_id: @presentation.id, id: survey.id })
    end

    it 'sets presentation as an instance variable' do
      presentation = assigns(:presentation)

      assert_equal @presentation, presentation, 'Expected presentation to be set as an instance variable'
    end

    it 'sets survey as an instance variable' do
      assigned_survey = assigns(:survey)

      assert_equal survey, assigned_survey, 'Expected survey to be set as an instance variable'
    end
  end


  describe '#create' do
    let(:success_params) do
      {
        presentation_id: @presentation.id,
        survey: {
          order: 1,
          title: 'Git'
        }
      }
    end

    let(:error_params) do
      {
        presentation_id: @presentation.id,
        survey: {
          order: 1,
          title: nil
        }
      }
    end

    before do
      @initial_count = Survey.count
    end

    it 'saves a survey with valid params' do
      post :create, params: success_params

      assert @initial_count < Survey.count, 'Did not save a valid survey'
    end

    it 'does not save a survey with invalid params' do
      post :create, params: error_params

      assert @initial_count == Survey.count, 'Saved an invalid survey'
    end

    it 'redirects to presentation surveys page after succesfully saving' do
      post :create, params: success_params

      assert_redirected_to presentation_survey_path(@presentation.id, @presentation.surveys.first.id), 'No redirect to presentations_survey_path'
    end
  end

  describe '#update' do
    let(:survey) { create(:survey, presentation_id: @presentation.id) }
    let(:new_position) { survey.position + 1 }
    let(:new_title) { 'Updated Title' }

    let(:success_params) do
      {
        presentation_id: @presentation.id,
        id: survey.id,
        survey: {
          position: new_position,
          title: new_title
        }
      }
    end
    let(:error_params) do
      {
        presentation_id: @presentation.id,
        id: survey.id,
        survey: {
          position: nil,
          title: nil
        }
      }
    end

    it 'updates question with valid params' do
      patch :update, params: success_params

      survey.reload

      assert_equal [new_title, new_position], [survey.title, survey.position], 'Survey title & position were not updated properly'
      assert_redirected_to presentation_survey_path(@presentation.id, survey.id), 'No redirect to presentation_survey_path'
    end

    it 'does not update questions with invalid params' do
      patch :update, params: error_params

      survey.reload

      refute_equal [new_title, new_position], [survey.title, survey.position], 'Survey title & position were updated with incorrect params'
    end
  end

  describe '#destroy' do
    let(:survey) { create(:survey, presentation_id: @presentation.id) }

    before do
      survey.reload
      @initial_count = Survey.count
    end

    it 'should delete a survey' do
      delete :destroy, params: {
        presentation_id: @presentation.id,
        id: survey.id
      }

      assert_equal Survey.count, @initial_count - 1, 'Delete method unsuccessful. Survey still exists.'
    end
  end
end
