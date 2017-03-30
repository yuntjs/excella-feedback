require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @admin = create(:user, :admin)
    @presentation = create(:presentation)

    sign_in @admin
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
      # assert_redirected_to presentation_survey_path(presentation.id, presentation.surveys.first.id), 'No redirect to presentations_survey_path'
    end

    it 'does not svae a survey with invalid params' do
      post :create, params: error_params

      assert @initial_count == Survey.count, 'Saved an invalid survey'
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
