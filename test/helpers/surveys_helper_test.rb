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
end
