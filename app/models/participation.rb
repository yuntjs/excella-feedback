class Participation < ApplicationRecord
  belongs_to :Presentation
  belongs_to :User
end
