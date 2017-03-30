#
# User model
#
class User < ApplicationRecord
  #
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participations, dependent: :destroy
  has_many :presentations, through: :participations, dependent: :destroy

  has_many :responses, dependent: :nullify
  has_many :questions, through: :responses, dependent: :nullify

  validates :first_name, :last_name, presence: true

  #
  # Provides full_name attribute for user
  #
  def full_name
    "#{first_name} #{last_name}"
  end

  #
  # Returns boolean value is user is a presenter of a given Presentation
  #
  def is_presenter?(presentation)
    participation = Participation.where(presentation_id: presentation.id).where(user_id: id)
    return participation.first.is_presenter if participation.first
    false
  end

  #
  # Returns boolean value if user has a Participation of a given Presentation
  #
  def has_participation?(presentation)
    Participation.where(presentation_id: presentation.id, user_id: id).present?
  end
end
