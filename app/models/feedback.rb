#
# Feedback PORO
# Wraps a user's feedback submission into one object
#
class Feedback
  attr_reader :user, :survey_data

  #
  # Set user, then extract survey details into survey_data array
  #
  def initialize(user, surveys)
    @user = user

    @survey_data = surveys.map do |survey|
      {
        title: survey.subject,
        questions: survey.questions
      }
    end
  end

  #
  # Create unsaved responses from form inputs
  #
  def add_responses(form_input: nil)
    @survey_data.each do |survey|
      survey[:responses] = survey[:questions].map do |question|
        value = form_input ? form_input[question.id.to_s] : nil

        question.responses.new(
          user_id: @user.id,
          value: value
        )
      end
    end
  end

  #
  # Checks whether feedback is valid by checking if all responses are valid
  # Note: calling response.invalid? sets errors on the response object
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
      survey[:responses].each(&:save)
    end
  end
end
