#
# Concern that holds common items between question & question template
#
module QuestionHelper
  extend ActiveSupport::Concern

  included do
    validates :prompt, presence: true
    validates :response_type, presence: true
    validates :response_required, inclusion: { in: [true, false] }

    before_create :lowercase_response_type
    before_update :lowercase_response_type
  end

  #
  # Change response type so that it is all lowercase letters
  #
  def lowercase_response_type
    response_type.downcase!
  end
end
