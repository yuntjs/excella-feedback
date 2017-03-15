require 'test_helper'

class PresentationsHelperTest < ActionView::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @user = create(:user)

    @presentation_as_presenter = create(:presentation)
    @presentation_as_attendee = create(:presentation)

    create(:participation,
           user_id: @user.id,
           presentation_id: @presentation_as_presenter.id,
           is_presenter: true)

    create(:participation,
           user_id: @user.id,
           presentation_id: @presentation_as_attendee.id,
           is_presenter: false)
  end

  describe '#presentations_as' do
    it 'gets correct presentations when current user is presenter' do
      presentations = presentations_as(:presenter, @user)

      assert_equal presentations, [@presentation_as_presenter]
    end

    it 'gets correct presentations where current user is attendee' do
      presentations = presentations_as(:attendee, @user)

      assert_equal presentations, [@presentation_as_attendee]
    end

    it 'returns an empty relation is role is not specified as presenter or attendee' do
      assert_equal presentations_as(:another_role, @user), []
    end

    it 'raises an error if role is not specified' do
      assert_raises(ArgumentError) { presentations_as(@user) }
    end

    it 'raises an error if user is not specified' do
      assert_raises(ArgumentError) { presentations_as(:presenter) }
    end
  end
end
