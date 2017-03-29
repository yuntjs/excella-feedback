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

  # def position_questions
  #   questions.sort_by(&:position)
  # end
end
