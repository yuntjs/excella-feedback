#
# Survey model
#
class Survey < ApplicationRecord
  belongs_to :presentation
  before_create :normalize_position
  before_update :normalize_position

  #
  # acts_as_list gem handles Survey order based on parent Presentation
  #
  acts_as_list scope: :presentation

  has_many :questions, dependent: :destroy

  validates :title, :position, presence: true

  #
  # Ensure that position is not too high
  #
  def normalize_position
    return unless position > presentation.surveys.count
    self.position = presentation.surveys.count
  end

  #
  # Get the highest survey position for a presentation
  #
  def self.highest_position(presentation)
    presentation.surveys.maximum(:position) || 0
  end

  #
  # Build unsaved survey from presentation & survey template
  #
  def self.build_from_template(survey_template, presentation)
    presentation.surveys.new(
      title: survey_template.title,
      position: Survey.highest_position(presentation) + 1
    )
  end
end
