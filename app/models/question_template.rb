#
# QuestionTemplate model
#
class QuestionTemplate < ApplicationRecord
  belongs_to :survey_template

  validates :prompt, :response_type, presence: true
  validates :response_required, inclusion: { in: [true, false] }
end
