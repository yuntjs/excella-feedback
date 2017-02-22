class Question < ApplicationRecord
  belongs_to :survey

  has_many :responses
  has_many :users, through: :responses
end
