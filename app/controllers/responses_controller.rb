class ResponsesController < ApplicationController
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.order_surveys
  end

  def create
    @responses = params[:question]

    @responses.each do |question_id, answer|
      response = Response.new(
        question_id: question_id,
        user_id: current_user.id,
        value: answer
      )

      if response.errors.any?
        flash.now[:error] = "There was an error with the submission."
        render :new
      end
    end

    flash[:success] = "Answer successfully recorded."
    redirect_to presentation_path(params[:presentation_id])
  end

  # TODO: sanitized params needed
end
