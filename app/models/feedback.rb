#
# Feedback PORO
# A feedback object is essentially  wrapper for a given user's feedback submission
#
class Feedback
  #
  # :user is the User that provided the feedback
  # :survey_data is an array of objects that stores survey titles, questions, & responses
  #
  attr_reader :user, :survey_data

  #
  # Set user, then create survey_data array from provided surveys
  #
  def initialize(user, surveys)
    @user = user

    @survey_data = surveys.map do |survey|
      {
      title: "#{survey.subject}",
      questions: survey.questions
      }
    end
  end

  def responses
    resps = []

    @survey_data.each do |survey|
      resps << survey[:responses]
    end

    resps.flatten
  end

  #
  # Create unsaved responses from form inputs
  #
  def set_responses(form_inputs: nil)
    @survey_data.each do |survey|
      survey[:responses] = survey[:questions].map do |question|
        value = form_inputs ? form_inputs[question.id.to_s] : nil

        question.responses.new(
          user_id: @user.id,
          value: value
        )
      end
    end
  end

  #
  # Checks whether feedback is valid by checking if all responses are valid
  #
  def valid?
    all_valid = true

    @survey_data.each do |survey|
      survey[:responses].each do |response|
        all_valid = false if response.invalid?
      end
    end

    all_valid
  end

  #
  # Saves all responses in survey_data
  #
  def save
    @survey_data.each do |survey|
      survey[:responses].each do |response|
        response.save
      end
    end
  end
end
