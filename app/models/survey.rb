class Survey < ApplicationRecord
  belongs_to :presentation

  has_many :questions, dependent: :destroy

  validates :order, presence: true
  validates :subject, presence: true

  def order_questions
    self.questions.sort_by {|q| q.order}
  end
end
