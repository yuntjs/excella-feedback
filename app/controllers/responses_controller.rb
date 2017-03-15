#
# ResponsesController
#
class ResponsesController < ApplicationController
  def new
    set_instance_variables

    @feedback.each do |survey|
      survey[:responses] = []

      survey[:questions].each do |question|
        survey[:responses] << question.responses.new(user_id: current_user.id)
      end
    end
  end

  def create # TODO: requires cleanup
    set_instance_variables

    @feedback.each do |survey|
      survey[:responses] = []

      survey[:questions].each do |question|
        survey[:responses] << question.responses.new(
          user_id: current_user.id,
          value: response_params[:question_id]["#{question.id.to_s}"])
      end
    end

    all_valid = true

    @feedback.each do |survey|
      survey[:responses].each do |response|
        next if response.valid?
        all_valid = false
      end
    end

    if all_valid
      @feedback.each do |survey|
        survey[:responses].each do |response|
          response.save
        end
      end
      flash[:success] = "Your responses have beeen successfully recorded."
      participation = Participation.where(
        user_id: current_user.id,
        presentation_id: @presentation.id
      ).first
      participation.set_feedback_provided
      redirect_to presentation_path(@presentation)
    else
      flash.now[:error] = "We ran into some errors while trying to save your responses. Please try again."
      render :new
    end
  end

  private

  #
  # Set and sanitize response parameters
  #
  def response_params
    params.require(:responses).permit!
  end

  #
  # Set variables to be used in routes
  #
  def set_instance_variables
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.position_surveys
    # @questions = Question.where(survey_id: @surveys.pluck(:id))
    @feedback = @surveys.map do |survey|
      {
      title: "#{survey.subject}",
      questions: survey.questions
      }
    end
  end
end
