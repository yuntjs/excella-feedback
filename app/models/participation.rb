#
# Participation model
#
class Participation < ApplicationRecord
  belongs_to :presentation
  belongs_to :user
end
