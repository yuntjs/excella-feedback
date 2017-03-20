#
# Feedback PORO
# A feedback object is just an object that holds multiple surveys
#
class Feedback
  attr_reader :surveys

  def initialize(surveys)
    @surveys = surveys

    @surveys = @surveys.map do |survey|
      {
      title: "#{survey.subject}",
      questions: survey.questions
      }
    end
  end

  def set_responses(user: nil, responses: nil)
    @surveys.each do |survey|
      survey[:responses] = survey[:questions].map do |question|
        response = question.responses.new

        response.user_id = user&.id
        response.value = responses.try(:question_id).try("#{question.id.to_s}")

        response
      end
    end
  end

  def valid?
    @surveys.each do |survey|
      survey[:responses].each do |response|
        return false unless response.valid?
      end
    end

    true
  end

  def save
    @surveys.each do |survey|
      survey[:responses].each do |response|
        response.save
      end
    end
  end
end
