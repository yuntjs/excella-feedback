#
# Question model
#
class Question < ApplicationRecord
  include QuestionHelper

  belongs_to :survey

  #
  # acts_as_list gem handles Question order based on parent Survey
  #
  acts_as_list scope: :survey

  has_many :responses, dependent: :destroy
  has_many :users, through: :responses, dependent: :destroy

  validates :position, presence: true

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

  #
  # Get the highest question position for a survey
  #
  def self.highest_position(survey)
    survey.questions.maximum(:position) || 0
  end

  #
  # Create questions from survey & question templates
  #
  def self.create_from_templates(survey:, question_templates:)
    count = 0

    question_templates.map do |question_template|
      count += 1

      survey.questions.create(
        prompt: question_template.prompt,
        response_type: question_template.response_type,
        response_required: question_template.response_required,
        position: count
      )
    end
  end
end
