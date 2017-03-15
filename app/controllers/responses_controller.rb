#
# ResponsesController
#
class ResponsesController < ApplicationController
  #
  # Index route
  #
  def index
    @presentation = Presentation.find(params[:presentation_id])
    @responses = Response.all
    # Save response data for integer responses
    set_chart_data(@presentation)
  end

  #
  # New route
  #
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.position_surveys
    @feedback = { errors: [] }
  end

  #
  # Create route
  #
  def create
    @feedback = { responses: params[:question], errors: [] }
    @feedback[:responses].each do |question_id, answer|
      response = Response.new(question_id: question_id, user_id: current_user.id, value: answer)
      unless response.save
        @feedback[:errors] << { question_id: question_id, error_obj: response.errors }
      end
    end

    if !@feedback[:errors].empty?
      @presentation = Presentation.find(params[:presentation_id])
      @surveys = @presentation.position_surveys
      render :new
    else
      flash[:success] = success_message(Response.new, :save)
      redirect_to presentations_path
    end
  end

  #
  # Show route
  #
  def show
  end

  private

  #
  # Set data for scale (number) question charts
  #
  def set_chart_data(presentation)
    @data = {}
    presentation.surveys.each do |survey|
      survey.questions.each do |question|
        if question.response_type == 'number'
          question_data = { 'Strongly Disagree': 0, 'Disagree': 0, 'Neutral': 0, 'Agree': 0, 'Strongly Agree': 0 }
          question.responses.each do |response|
            res_value = response.value.to_sym
            case res_value
            when :'1'
              res_value = :'Strongly Disagree'
            when :'2'
              res_value = :'Disagree'
            when :'3'
              res_value = :'Neutral'
            when :'4'
              res_value = :'Agree'
            when :'5'
              res_value = :'Strongly Agree'
            end
            question_data[res_value] += 1
          end
          @data[question.id] = question_data
        end
      end
    end
  end
end
