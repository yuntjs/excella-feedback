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

  validates :title, :position, presence: true

  #
  # Get the highest survey position for a presentation
  #
  def self.highest_position(presentation)
    presentation.surveys.maximum(:position) || 0
  end

  #
  # Create survey from presentation & survey template
  #
  def self.build_from_template(presentation:, survey_template:)
    presentation.surveys.new(
      title: survey_template.title,
      position: Survey.highest_position(presentation) + 1
    )
  end
end
