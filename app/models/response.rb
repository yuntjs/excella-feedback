#
# Response model
#
class Response < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :value, presence: true
  validate :unique_response, on: :create, unless: 'question_id.nil?' || 'user_id.nil?'

  #
  # Check if user has already submitted a response for a given question
  #
  def unique_response
    response = Response.where(question_id: question.id, user_id: user.id)
    return if response.empty?
    errors.add(:unique_response, 'A response has already been submitted for this question.')
  end
end
