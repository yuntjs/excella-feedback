class Presentation < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations, dependent: :destroy

  has_many :surveys, dependent: :destroy

  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true
end
