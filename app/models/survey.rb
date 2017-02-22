class Survey < ApplicationRecord
  belongs_to :presentation

  has_many :questions
end
