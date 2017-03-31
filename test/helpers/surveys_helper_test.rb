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
    @presenter_survey = create(:survey, presentation_id: @presentation.id, presenter_id: @presenter.id)
  end

  describe '#new_survey_action_button' do
    let(:no_options) { new_survey_action_button(@user, @presentation) }
    let(:presenter_options) { new_survey_action_button(@presenter, @presentation) }

    it 'returns nil if user is not admin nor presenter' do
      assert_nil no_options, 'Returns something other than nil for basic user'
    end

    it 'returns a link to create new surveys for presenter' do
      assert_includes presenter_options, new_presentation_survey_path(@presentation), 'Does not contain a link to create new surveys'
    end
  end

  describe '#survey_option_buttons' do
    let(:options) { survey_option_buttons }

    it 'returns an edit survey link' do
      assert_includes options, edit_presentation_survey_path(@presentation, @survey), 'Does not include link to edit survey'
    end

    it 'returns a delete survey link' do
      assert_includes options, presentation_survey_path(@presentation, @survey), 'Does not include link to delete survey'
    end
  end

  describe '#survey_option_buttons' do
    let(:options) { survey_option_buttons(@survey) }
    let(:current_user) { @user }

    it 'returns an edit survey link' do
      assert_includes options, edit_presentation_survey_path(@presentation, @survey), 'Does not include link to edit survey'
    end

    it 'returns a delete survey link' do
      assert_includes options, presentation_survey_path(@presentation, @survey), 'Does not include link to delete survey'
    end
  end

  describe '#disable_check' do
    it 'returns nil if a survey is not associated with any presenter' do
      check = disable_check(@survey, @user)

      assert_nil check, 'Returns something other than nil when survey does not have a presenter'
    end

    it 'returns nil for admin' do
      check = disable_check(@presenter_survey, @admin)

      assert_nil check, 'Returns something other than nil when user is admin'
    end

    it 'returns nil when survey presenter is the user' do
      check = disable_check(@presenter_survey, @presenter)

      assert_nil check, 'Returns something other than nil when user is survey presenter'
    end

    it 'returns a css class to disable links when user is not admin nor the associated presenter for the survey' do
      css_class = 'disabled'
      different_presenter = create(:user)

      check = disable_check(@presenter_survey, different_presenter)

      assert_equal css_class, check, "Does not return css class: #{css_class}"
    end
  end
end
