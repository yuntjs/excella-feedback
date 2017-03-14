#
# Participation model test
#
require 'test_helper'

describe Participation do
  before do
    @user = create(:user)
    @presentation = create(:presentation)
    @participation = create(:participation,
      user_id: @user.id,
      presentation_id: @presentation.id,
      is_presenter: false,
      feedback_provided: false
    )
  end

  describe '#set_feedback_provided' do
    it 'sets feedback provided to true for a participation' do
      @participation.set_feedback_provided

      assert @participation.feedback_provided, 'feedback_provided is still set to false'
    end
  end
end
