class Survey < ApplicationRecord
  belongs_to :presentation

  has_many :questions, dependent: :destroy

  validates :order, presence: true
  validates :subject, presence: true
end
