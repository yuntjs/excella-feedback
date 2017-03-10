#
# ResponsesController
#
class ResponsesController < ApplicationController
  def new # TODO: requires cleanup
    set_instance_variables

    @responses = []
    @questions.each do |question|
      @responses << question.responses.new(user_id: current_user.id)
    end
  end

  def create # TODO: requires cleanup
    set_instance_variables

    @responses = []
    @questions.each do |question|
      @responses << question.responses.new(
        user_id: current_user.id,
        value:   response_params[:question_id]["#{question.id.to_s}"]
      )
    end

    all_valid = true

    @responses.each do |response|
      binding.pry
      next if response.valid?
      all_valid = false
    end

    if all_valid
      @responses.each do |response|
        response.save
      end
    end


    # presentation = Presentation.find(params[:presentation_id])
    # surveys = presentation.surveys
    #
    # question_ids = surveys.map do |survey|
    #   survey.questions.pluck(:id)
    # end.flatten # TODO: extract out somewhere else
    #
    # responses = response_params(question_ids)

    # @feedback = {
    #   responses: params[:question],
    #   errors: []
    # }
    # @feedback[:responses].each do |question_id, answer|
    #     response = Response.new(
    #       question_id: question_id,
    #       user_id: current_user.id,
    #       value: answer)
    #     if !response.save
    #       @feedback[:errors] << {question_id: question_id, error_obj: response.errors}
    #     end
    # end
    #
    # if @feedback[:errors].length > 0
    #   flash.now[:error] = error_message(Response.new, :save)
    #   @presentation = Presentation.find(params[:presentation_id])
    #   @surveys = @presentation.order_surveys
    #   render :new
    # else
    #   flash[:success] = success_message(Response.new, :save)
    #   redirect_to presentations_path
    # end
  end

  # def show
  #
  # end

  private

  def response_params
    params.require(:responses).permit!
  end

  def set_instance_variables
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.order_surveys
    @questions = Question.where(survey_id: @surveys.pluck(:id))
  end
end
