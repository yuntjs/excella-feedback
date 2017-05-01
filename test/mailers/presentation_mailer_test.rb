require 'test_helper'

class PresentationMailerTest < ActionMailer::TestCase
  before do
    @user = create(:user)
    @presentation = create(:presentation)

    create(:participation, user: @user, presentation: @presentation)
  end

  describe '.notify' do
    let(:email) { PresentationMailer.notify(user: @user, presentation: @presentation) }

    it 'is added to the queue when sent' do
      assert_emails 1 do
        email.deliver_now
      end
    end
  end
end
