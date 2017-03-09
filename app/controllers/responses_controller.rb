class ResponsesController < ApplicationController
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.order_surveys
  end

  def create
    presentation = Presentation.find(params[:presentation_id])
    surveys = presentation.surveys

    question_ids = surveys.map do |survey|
      survey.questions.pluck(:id)
    end.flatten # TODO: extract out somewhere else

    responses = response_params(question_ids)

    # for each question
    #   response = Response.new(response_params)
    #   error validation
    #   saving
    #   etc
    # end

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
      # params.permit(questions: {})
      params.require(:response).permit(:question_id, :user_id, :value)
    end
end
