#
# Survey model
#
class Survey < ApplicationRecord
  belongs_to :presentation

  #
  # acts_as_list gem handles Survey order based on parent Presentation
  #
  acts_as_list scope: :presentation

  has_many :questions, dependent: :destroy

  # validates :order, presence: false
  validates :title, presence: true

  #
  # Order questions by position
  #
  # def position_questions
  #   questions.order(:position)
  # end

  #
  # Create survey from presentation & survey_template
  #
  def self.create_from_template(presentation:, survey_template:)
    presentation.surveys.new(
      title: survey_template.id,
      position: presentation.surveys.maximum(:position) + 1,
      presenter_id: nil
    )
  end
end
