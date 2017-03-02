class ResponsesController < ApplicationController
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.order_surveys
  end

  def create
    all_responses = params[:question]
    all_responses.each do |question_id, answer|
        response = Response.new(question_id: question_id, user_id: current_user.id, value: answer)
        response.save ? flash[:notice] = "Answer successfully recorded" : flash[:error] = "User has already submitted a repsonse to this question"
    end
    redirect_to presentation_path(params[:presentation_id])
  end
end
