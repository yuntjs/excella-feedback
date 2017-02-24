class Presentation < ApplicationRecord
  has_many :participations
  has_many :users, through: :participations

  has_many :surveys

  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true
end
