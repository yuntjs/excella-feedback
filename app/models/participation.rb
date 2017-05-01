#
# Participation model
#
class Participation < ApplicationRecord
  belongs_to :presentation
  belongs_to :user

  after_create :survey_notify_email

  #
  # Changes feedback_provided to true
  #
  def set_feedback_provided
    self.feedback_provided = true
    save
  end

  #
  # Send a survey notification email a certain period after presentation time
  #
  def survey_notify_email
    return if is_presenter

    PresentationMailer.notify(
      user: user,
      presentation: presentation
    ).deliver_later(wait_until: presentation.date + 30.minutes)
  end
end
