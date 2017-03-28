require 'test_helper'

class PresentationsHelperTest < ActionView::TestCase
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
    it 'returns nil if user is not admin nor presenter' do
      assert_nil survey_options(@user, @presentation), 'Returns something other than nil for basic user'
    end
  end
end
