require 'test_helper'

class PresentationMailerTest < ActionMailer::TestCase
  before do
    @user = create(:user)
    @presentation = create(:presentation)

    create(:participation, user: @user, presentation: @presentation)
  end

  describe '.notify' do
    let(:email) { PresentationMailer.notify(user: @user, presentation: @presentation) }

    it 'sends an email to the user' do
      assert_equal [@user.email], email.to, 'Expected email to be sent to user email'
    end

    it 'contains the proper subject line' do
      assert_equal "Excella Onboarding - Quick Survey on #{@presentation.title}!", email.subject
    end
  end
end
