require 'question_concern'

class QuestionsController < ApplicationController
  include Questionable

  helper_method :question

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

  def edit
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:survey_id])
    @question = question
  end

  def update
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:survey_id])

    if question.update(question_params)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    else
      render :edit
    end
  end

  def destroy
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.find(params[:id])

    @question.destroy
    redirect_to presentation_survey_path(@presentation.id, @survey.id)

  end


end
