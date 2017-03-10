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

  def order_surveys
    surveys.sort_by(&:order)
  end

  def description_short(length)
    return unless length < 1
    description[0..length].gsub(/\s\w+\s*$/, '...')
    #raise ArgumentError
  end
end
