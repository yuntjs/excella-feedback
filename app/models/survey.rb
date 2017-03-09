class Survey < ApplicationRecord
  belongs_to :presentation

  #
  # acts_as_list gem handles Survey order based on parent Presentation
  #
  acts_as_list scope: :presentation

  has_many :questions, dependent: :destroy

  validates :order, presence: true
  validates :subject, presence: true

  # TODO remove order from schema
  def order_questions
    self.questions.sort_by {|q| q.order}
  end
end
