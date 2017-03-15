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
  # Order surveys by :order
  # TODO remove and use acts_as_list
  #
  def position_surveys
    self.surveys.sort_by{|survey| survey.position}
  end

  #
  # Shorten long presentation descriptions for Presentation#index
  #
  def description_short(length)
    if length < 1
      raise ArgumentError
    else
      description[0..length].gsub(/\s\w+\s*$/, '...')
    end
  end
end
