#
# QuestionTemplate model
#
class QuestionTemplate < ApplicationRecord
  include QuestionHelper

  belongs_to :survey_template
end
