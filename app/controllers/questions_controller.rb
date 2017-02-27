class QuestionsController < ApplicationController
  def new
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:survey_id])
    @question = Question.new
  end

  def create

  end

  def show

  end
end
