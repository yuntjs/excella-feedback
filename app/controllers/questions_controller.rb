class QuestionsController < ApplicationController
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:survey_id])
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.survey_id = params[:survey_id]
    @presentation = Presentation.find(params[:presentation_id])

    if @question.save
      redirect_to presentation_survey_path(@presentation.id, @question.survey_id)
    else
      render :new
    end
  end

  def show

  end

  private
  def question_params
    params.require(:question).permit(:order, :prompt, :response_type)
  end
end
