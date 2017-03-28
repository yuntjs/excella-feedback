require 'test_helper'

class SurveysHelperTest < ActionView::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @user = create(:user)
    @presenter = create(:user)
    @admin = create(:user, :admin)
    @presentation = create(:presentation)
    create(:participation,
           user_id: @user.id,
           presentation_id: @presentation.id,
           is_presenter: false)
    create(:participation,
           user_id: @presenter.id,
           presentation_id: @presentation.id,
           is_presenter: true)
    @survey = create(:survey, presentation_id: @presentation.id)
  end

  describe '#survey_admin_options' do
    let(:no_options) { survey_admin_options(@user, @presentation) }
    let(:presenter_options) { survey_admin_options(@presenter, @presentation) }

    it 'returns nil if user is not admin nor presenter' do
      assert_nil no_options, 'Returns something other than nil for basic user'
    end

    it 'returns a link to create new surveys for presenter' do
      assert_includes presenter_options, new_presentation_survey_path(@presentation), 'Does not contain a link to create new surveys'
    end
  end

  describe '#survey_options' do
    let(:options) { survey_options }
    it 'returns an edit survey link' do
      assert_includes options, edit_presentation_survey_path(@presentation, @survey), 'Does not include link to edit survey'
    end

    it 'returns a delete survey link' do
      assert_includes options, presentation_survey_path(@presentation, @survey), 'Does not include link to delete survey'
    end
  end

  describe '#survey_index_options' do
    let(:options) { survey_index_options(@survey) }
    let(:current_user) { @user }
    it 'returns an edit survey link' do
      assert_includes options, edit_presentation_survey_path(@presentation, @survey), 'Does not include link to edit survey'
    end

    it 'returns a delete survey link' do
      assert_includes options, presentation_survey_path(@presentation, @survey), 'Does not include link to delete survey'
    end
  end

  describe '#disable_check' do
    it 'PENDING'
  end
end
