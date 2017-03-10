class Question < ApplicationRecord
  belongs_to :survey

  #
  # acts_as_list gem handles Question order based on parent Survey
  #
  acts_as_list scope: :survey


  has_many :responses, dependent: :destroy
  has_many :users, through: :responses, dependent: :destroy
end
