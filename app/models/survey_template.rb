#
# SurveyTemplate model
#
class SurveyTemplate < ApplicationRecord
  has_many :question_templates, dependent: :destroy

  validates :title, presence: true
  validates :name, presence: true
end
