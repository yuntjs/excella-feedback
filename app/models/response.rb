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
    errors.add(:unique_response, '- a response has already been submitted for this question.')
  end

  #
  # Check if response is required for a question
  #
  def require_question
    return unless question.response_required
    return unless value.nil? || value.empty?
    errors.add(:required_question, '- please provide a response.')
  end
end
