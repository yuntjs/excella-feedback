require 'test_helper'

class PresentationsHelperTest < ActionView::TestCase
  # include Warden::Test::Helpers
  # Warden.test_mode!

  before do
    @user = create(:user)
    # login_as(@user, scope: :user)

    @presentation_as_presenter = create(:presentation)
    @presentation_as_attendee = create(:presentation)

    create(:participation,
      user_id: @user.id,
      presentation_id: @presentation_as_presenter.id,
      is_presenter: true
    )
    create(:participation,
      user_id: @user.id,
      presentation_id: @presentation_as_attendee.id,
      is_presenter: false
    )
  end

  # after do
  #   Warden.test_reset!
  # end

  describe '#presentations_as' do
    it 'gets correct presentations when current user is presenter' do
      assert_equal presentations_as(:presenter, @user), [@presentation_as_presenter]
    end

    it 'gets correct presentations where current user is attendee'
    it 'returns an empty relation is role is not specified as presenter or attendee'
    it 'raises an error if role is not specified'
  end
end
