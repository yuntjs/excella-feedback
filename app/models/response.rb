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

  def unique_response
    response = Response.where(question_id: question.id, user_id: user.id)
    unless response.empty?
      errors.add(:unique_response, 'A response has already been submitted for this question.')
    end
  end
end
