#
# ResponsesController
#
class ResponsesController < ApplicationController
  before_action :authenticate_admin_or_presenter, only: [:index]
  #
  # Render response data
  #
  def index
    @presentation = Presentation.find(params[:presentation_id])
    @responses = Response.all
    # Save response data for integer responses
    build_chart_data(@presentation)
  end

  #
  # Create a feedback object with unsaved responses
  #
  def new
    set_instance_variables
    @feedback.add_responses
  end

  #
  # Save valid feedback & re-render invalid feedback
  #
  def create
    set_instance_variables
    @feedback.add_responses(form_input: response_params[:question_id])

    if @feedback.valid?
      @feedback.save
      flash[:success] = 'Your responses have beeen successfully recorded.'
      mark_participation(@presentation)
      redirect_to presentation_path(@presentation)
    else
      flash.now[:error] = 'We ran into some errors while trying to save your responses. Please try again.'
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
    @surveys = @presentation.surveys.order(:position)
    @feedback = Feedback.new(current_user, @surveys)
  end

  #
  # Find participation & set feedback as provided
  #
  def mark_participation(presentation)
    participation = Participation.where(
      user_id: current_user.id,
      presentation_id: presentation.id
    ).first

    participation.set_feedback_provided
  end

  #
  # Set data for scale (number) question charts
  #
  def build_chart_data(presentation)
    @data = {}
    @average = {}
    presentation.surveys.each do |survey|
      survey.questions.each do |question|
        next unless question.response_type == 'number'
        get_question_data(question)
        next unless question.responses.any?
        get_average(question)
      end
    end
  end

  #
  # Format data properly for chartkick
  #
  def format_question_data(question)
    question_data = { 'Strongly Disagree': 0, 'Disagree': 0, 'Neutral': 0, 'Agree': 0, 'Strongly Agree': 0 }
    question.responses.each do |response|
      res_value = response.value.to_sym
      case res_value
      when :'1'
        res_value = :'Strongly Disagree'
      when :'2'
        res_value = :Disagree
      when :'3'
        res_value = :Neutral
      when :'4'
        res_value = :Agree
      when :'5'
        res_value = :'Strongly Agree'
      end
      question_data[res_value] += 1
    end
    question_data
  end

  #
  # Define and format data for number (scale) questions
  #
  def get_question_data(question)
    return unless question.response_type == 'number'
    question_data = format_question_data(question)
    @data[question.id] = question_data
  end

  #
  # Get sum of numerical responses to a question
  #
  def get_sum(question)
    sum = 0
    question.responses.each do |response|
      sum += response.value.to_i
    end
    sum
  end

  #
  # Return average of numerical responses for given question
  #
  def get_average(question)
    return unless question.response_type == 'number'
    return unless question.responses.any?
    sum = get_sum(question)
    @average[question.id] = sum / question.responses.length
  end
end
