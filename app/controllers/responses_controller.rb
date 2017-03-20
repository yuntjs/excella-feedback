#
# ResponsesController
#
class ResponsesController < ApplicationController
  #
  # Index
  #
  def index
    @presentation = Presentation.find(params[:presentation_id])
    @responses = Response.all
    # Save response data for integer responses
    set_chart_data(@presentation)
  end

  #
  # New
  # Creates a feedback object with unsaved responses
  #
  def new
    set_instance_variables
    @feedback.set_responses(user: current_user)
  end

  #
  # Create
  # Saves valid responses, re-renders invalid submissions
  #
  def create
    set_instance_variables
    @feedback.set_responses(user: current_user, responses: response_params)

    if @feedback.valid?
      @feedback.save
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
    @feedback = Feedback.new(@surveys)
  end

  #
  # Set data for scale (number) question charts
  #
  def set_chart_data(presentation)
    @data = {}
    @average = {}

    presentation.surveys.each do |survey|
      survey.questions.each do |question|
        if question.response_type == 'number'
          question_data = { 'Strongly Disagree': 0, 'Disagree': 0, 'Neutral': 0, 'Agree': 0, 'Strongly Agree': 0 }
          sum = 0
          question.responses.each do |response|
            res_value = response.value.to_sym
            case res_value
            when :'1'
              sum += 1
              res_value = :'Strongly Disagree'
            when :'2'
              sum += 2
              res_value = :'Disagree'
            when :'3'
              sum += 3
              res_value = :'Neutral'
            when :'4'
              sum += 4
              res_value = :'Agree'
            when :'5'
              sum += 5
              res_value = :'Strongly Agree'
            end
            question_data[res_value] += 1
          end

          @data[question.id] = question_data
          return if question.responses.length == 0
          @average[question.id] = sum / question.responses.length
        end
      end
    end
  end
end
