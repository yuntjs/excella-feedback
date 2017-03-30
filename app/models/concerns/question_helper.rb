#
# Concern that holds common items between question & question template
#
module QuestionHelper
  extend ActiveSupport::Concern

  included do
    validates :prompt, :response_type, presence: true
    validates :response_required, inclusion: { in: [true, false] }
  end
end
