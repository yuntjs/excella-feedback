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

  validates :prompt, presence: true
  validates :response_type, presence: true
  validates :response_required, inclusion: { in: [true, false] }

  #
  # Values for Presentation survey questions
  #
  def self.default_presentation_questions
    [
      { prompt: 'I thought this course effectively taught the subject matter.',
        response_type: 'number' }, {
          prompt: 'I thought this course was relevant to my future projects.',
          response_type: 'number'
        }, {
          prompt: 'Do you have any additional comments?',
          response_type: 'text'
        }
    ]
  end

  #
  # Values for Presenter survey questions
  #
  def self.default_presenter_questions(presenter)
    [
      { prompt: "I thought #{presenter.full_name} effectively taught the subject matter.",
        response_type: 'number' }, {
          prompt: "I thought #{presenter.full_name} answered questions effectively.",
          response_type: 'number'
        }, {
          prompt: "Do you have any additional comments for #{presenter.full_name}?",
          response_type: 'text'
        }
    ]
  end
end
