#
# Presentation model
#
class Presentation < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations, dependent: :destroy

  has_many :surveys, dependent: :destroy

  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true

  #
  # Order surveys by position
  #
  def position_surveys
    surveys.order(:position)
  end

  #
  # Shorten long presentation descriptions for Presentation#index
  #
  def description_short(length)
    return raise ArgumentError if length < 1
    description[0..length].gsub(/\s\w+\s*$/, '...')
  end
end
