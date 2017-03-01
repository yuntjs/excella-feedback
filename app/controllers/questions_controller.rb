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

  def edit
    set_instance_variables
  end

  def update
    set_instance_variables

    if @question.update(question_params)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    else
      render :edit
    end
  end

  def destroy
    set_instance_variables

    @question.destroy
    redirect_to presentation_survey_path(@presentation.id, @survey.id)
  end


private

  def question_params
    params.require(:question).permit(:order, :prompt, :response_type)
  end

  def set_instance_variables
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.find(params[:id])
  end

end
