#
# Question model
#
class Question < ApplicationRecord
  belongs_to :survey

  #
  # acts_as_list gem handles Question order based on parent Survey
  #
  acts_as_list scope: :survey

  has_many :responses, dependent: :destroy
  has_many :users, through: :responses, dependent: :destroy

  #
  # Values for default survey questions
  #
  def self.default_presentation_questions
    a = [
    { prompt: "I thought this course was really great.",
      response_type: "scale" }
    ]
  end
end
