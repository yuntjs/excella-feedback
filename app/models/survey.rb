class Survey < ApplicationRecord
  belongs_to :presentation

  #
  # acts_as_list gem handles Survey order based on parent Presentation
  #
  acts_as_list scope: :presentation

  has_many :questions, dependent: :destroy

  validates :order, presence: true
  validates :subject, presence: true

  # survey_list = Presentation.find()
  # survey_list.surveys.first.move_to_bottom
  # survey_list.surveys.last.move_higher

  def order_questions
    self.questions.sort_by {|q| q.order}
  end
end
