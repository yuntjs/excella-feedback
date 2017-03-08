class ResponsesController < ApplicationController
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.order_surveys
    @feedback = { errors: [] }
  end

  def create
    @feedback = {
      responses: params[:question],
      errors: []
    }
    @feedback[:responses].each do |question_id, answer|
        response = Response.new(
          question_id: question_id,
          user_id: current_user.id,
          value: answer)
        if !response.save
          @feedback[:errors] << {question_id: question_id, error_obj: response.errors}
        end
    end

    if @feedback[:errors].length > 0
      @presentation = Presentation.find(params[:presentation_id])
      @surveys = @presentation.order_surveys
      render :new
    else
      flash[:success] = success_message(Response.new, :save)
      redirect_to presentations_path
    end
  end

  def show

  end
end
