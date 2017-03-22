#
# QuestionTemplate model
#
class QuestionTemplate < ApplicationRecord
  belongs_to :survey_template

  validates :prompt, presence: true
  validates :response_type, presence: true
  validates :response_required, presence: true
end
