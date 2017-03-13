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
    questions = [
      { prompt: "I thought this course effectively taught the subject matter.",
        response_type: "scale"
      }, {
        prompt: "I thought this course was relevant to my future projects.",
        response_type: "scale"
      }, {
        prompt: "Do you have any additional comments?",
        response_type: "text"
      }
    ]
  end
end
