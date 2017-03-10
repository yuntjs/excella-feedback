class Presentation < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations, dependent: :destroy

  has_many :surveys, dependent: :destroy

  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true


  def position_surveys
    self.surveys.sort_by{|survey| survey.position}
  end

  def description_short(length)
    if length < 1
      raise ArgumentError
    else
      description[0..length].gsub(/\s\w+\s*$/, '...')
    end
  end
end
