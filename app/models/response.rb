class Response < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :value, presence: true
  # validate :unique_response, on: :create

  def unique_response
    byebug
    if Response.where(question_id: question.id, user_id: user.id)
      errors.add(:unique_response, "user has already recorded a response for this question")
    end
  end
end
