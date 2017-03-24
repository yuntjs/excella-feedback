#
# QuestionTemplate model
#
class QuestionTemplate < ApplicationRecord
  before_create :lowercase_response_type

  belongs_to :survey_template

  validates :prompt, presence: true
  validates :response_type, presence: true
  validates :response_required, inclusion: { in: [true, false] }

  private

  def lowercase_response_type
    self.response_type.downcase!
  end
end
