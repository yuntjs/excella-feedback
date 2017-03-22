#
# Feedback PORO
# Wraps a user's feedback submission into one object
#
class Feedback
  attr_reader :user, :data

  #
  # Set user
  # Extract survey details into 'data' array, which stores 1 object for each survey
  # Each object in 'data' stores a given survey's title, questions, and (later) responses
  #
  def initialize(user, surveys)
    @user = user

    @data = surveys.map do |survey|
      {
        survey_title: survey.title,
        survey_questions: survey.questions
      }
    end
  end

  #
  # Create unsaved responses from form inputs
  #
  def add_responses(form_input: nil)
    @data.each do |d|
      d[:survey_responses] = d[:survey_questions].map do |question|
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

    @data.each do |d|
      d[:survey_responses].each do |response|
        all_valid = false if response.invalid?
      end
    end

    all_valid
  end

  #
  # Saves all responses in data
  #
  def save
    @data.each do |d|
      d[:survey_responses].each(&:save)
    end
  end
end
