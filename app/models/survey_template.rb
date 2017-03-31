#
# SurveyTemplate model
#
class SurveyTemplate < ApplicationRecord
  has_many :question_templates, dependent: :destroy

  validates :title, :name, presence: true
end
