require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create :user, :admin
    @presentation = create :presentation

    sign_in @admin
  end

  describe '#create' do
    it 'should create a new survey if User is an Admin' do
      post :create, params: {
        presentation_id: @presentation.id,
        survey: {
          title: 'Git',
          position: 1
        }
      }

      assert_redirected_to presentation_survey_path(@presentation.id, @presentation.surveys.first.id), 'No redirect to presentations_survey_path'
    end
  end

  describe '#update' do
    it 'should allow Admin user to Update surveys' do
      survey = create :survey, title: 'Git', presentation_id: @presentation.id

      updated_title = 'Git 2'
      updated_position = 2

      patch :update, params: {
        presentation_id: @presentation.id,
        id: survey.id,
        survey: {
          position: updated_position,
          title: updated_title
        }
      }

      survey.reload

      assert_equal [updated_title, updated_position], [survey.title, survey.position], 'Survey title & position was not updated properly'
      assert_redirected_to presentation_survey_path(@presentation.id, survey.id), 'No redirect to presentation_survey_path'
    end
  end

  describe '#destroy' do
    it 'should allow Admin user to Delete surveys' do
      survey = create :survey, presentation_id: @presentation.id

      delete :destroy, params: {
        presentation_id: @presentation.id,
        id: survey.id
      }

      assert_equal Survey.count, 0, 'Delete method unsuccessful. Survey still exists.'
    end
  end
end
