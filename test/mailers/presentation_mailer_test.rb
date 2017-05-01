require 'test_helper'

class PresentationMailerTest < ActionMailer::TestCase
  before do
    @user = create(:user)
    @presentation = create(:presentation)

    create(:participation, user: @user, presentation: @presentation)
  end

  describe '.notify' do
    let(:email) { PresentationMailer.notify(user: @user, presentation: @presentation) }

    it 'adds email to the queue when sent' do
      assert_emails 1 do
        email.deliver_now
      end
    end

    it 'sends to user email' do
      assert_equal [@user.email], email.to, 'Expected email to be sent to user email'
    end

    it 'contains the proper subject line' do
      assert_equal "Excella Onboarding - Quick Survey on #{@presentation.title}!", email.subject
    end
  end
end
