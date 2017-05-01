#
# Presentation Mailer
#
class PresentationMailer < ApplicationMailer
  def notify(user:, presentation:)
    @user = user
    @presentation = presentation
    mail(to: @user.email, subject: "Excella Onboarding - Quick Survey on #{@presentation.title}!")
  end
end
