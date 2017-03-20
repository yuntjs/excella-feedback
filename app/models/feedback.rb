#
# Feedback PORO
# A feedback object is a wrapper for a given user's feedback submission
#
class Feedback
  attr_reader :user, :feedback

  def initialize(user, surveys)
    @user = user

    @feedback = surveys.map do |survey|
      {
      title: "#{survey.subject}",
      questions: survey.questions
      }
    end
  end

  def set_responses(responses: nil)
    @feedback.each do |survey_info|
      survey[:responses] = survey[:questions].map do |question|
        response = question.responses.new

        response.user_id = @user.id
        response.value = responses.try(:question_id).try("#{question.id.to_s}")

        response
      end
    end
  end

  def valid?
    @feedbacks.each do |survey_info|
      survey[:responses].each do |response|
        return false unless response.valid?
      end
    end

    true
  end

  def save
    @feedbacks.each do |survey_info|
      survey[:responses].each do |response|
        response.save
      end
    end
  end
end
