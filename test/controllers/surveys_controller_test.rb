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
    before do
      @test_survey = create(:survey, presentation_id: @presentation.id)

      get(:show, params: { presentation_id: @presentation.id, id: @test_survey.id })
    end

    it 'sets presentation as an instance variable' do
      presentation = assigns(:presentation)

      assert_equal @presentation, presentation, 'Expected presentation to be set as an instance variable'
    end

    it 'sets survey as an instance variable' do
      assigned_survey = assigns(:survey)

      assert_equal @test_survey, assigned_survey, 'Expected survey to be set as an instance variable'
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

  # describe '#update' do
  #   it 'should allow Admin user to Update surveys' do
  #     admin = create :user, :admin
  #     presentation = create :presentation
  #     survey = create :survey, title: 'Git', presentation_id: presentation.id
  #
  #     updated_title = 'Git 2'
  #     updated_position = 2
  #
  #     sign_in admin
  #
  #     patch :update, params: {
  #       presentation_id: presentation.id,
  #       id: survey.id,
  #       survey: {
  #         position: updated_position,
  #         title: updated_title
  #       }
  #     }
  #
  #     survey.reload
  #     assert_equal [updated_title, updated_position], [survey.title, survey.position], 'Survey title & position was not updated properly'
  #     assert_redirected_to presentation_survey_path(presentation.id, survey.id), 'No redirect to presentation_survey_path'
  #   end
  # end
  #
  # describe '#destroy' do
  #   it 'should allow Admin user to Delete surveys' do
  #     admin = create :user, :admin
  #     presentation = create :presentation
  #     survey = create :survey, presentation_id: presentation.id
  #
  #     sign_in admin
  #
  #     delete :destroy, params: {
  #       presentation_id: presentation.id,
  #       id: survey.id
  #     }
  #
  #     assert_equal Survey.count, 0, 'Delete method unsuccessful. Survey still exists.'
  #   end
  # end
end
