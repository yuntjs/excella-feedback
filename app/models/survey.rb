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
  # Normalize survey positions for a presentation so they are in sequential order
  #
  def self.normalize_position(presentation)
    presentation.surveys.order(:position).each_with_index do |survey, index|
      survey.position = index + 1
      survey.save
    end
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
