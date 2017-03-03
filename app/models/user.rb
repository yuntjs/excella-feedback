class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participations, dependent: :destroy
  has_many :presentations, through: :participations, dependent: :destroy

  has_many :responses, dependent: :nullify
  has_many :questions, through: :responses, dependent: :nullify

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    full_name = "#{first_name} #{last_name}"
  end

  def is_presenter? presentation
    participation = Participation.where(presentation_id: presentation.id).where(user_id: self.id)
    if participation
      return participation.first.is_presenter
    end
    false
  end
end
