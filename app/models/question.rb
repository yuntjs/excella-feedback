#
# Question model
#
class Question < ApplicationRecord
  belongs_to :survey

  has_many :responses, dependent: :destroy
  has_many :users, through: :responses, dependent: :destroy
end
