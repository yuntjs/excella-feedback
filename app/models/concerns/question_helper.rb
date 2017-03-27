module QuestionHelper
  extend ActiveSupport::Concern

  included do
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
