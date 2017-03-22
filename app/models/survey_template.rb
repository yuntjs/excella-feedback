#
# SurveyTemplate model
#
class SurveyTemplate < ApplicationRecord
  has_many :question_templates, dependent: :destroy
end
