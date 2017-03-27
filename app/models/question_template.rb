#
# QuestionTemplate model
#
class QuestionTemplate < ApplicationRecord
  include QuestionHelper

  belongs_to :survey_template

  validates :prompt, presence: true
  validates :response_type, presence: true
  validates :response_required, inclusion: { in: [true, false] }
end
