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
end
