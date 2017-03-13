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
  validates :subject, presence: true

  # TODO: remove order from schema
  def position_questions
    self.questions.sort_by {|q| q.position}
  #   questions.sort_by(&:order)
  end
end
