#
# Participation model
#
class Participation < ApplicationRecord
  belongs_to :presentation
  belongs_to :user

  #
  # Changes feedback_provided to true
  #
  def set_feedback_provided
    self.feedback_provided = true
    save
  end
end
