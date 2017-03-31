#
# QuestionsController
#
class QuestionsController < ApplicationController
  before_action :set_presentation, only: [:new, :create]

  #
  # New route
  #
  def new
    @survey = Survey.find(params[:survey_id])
    @question = Question.new
  end

  #
  # Create route
  #
  def create
    @survey = Survey.find(params[:survey_id])
    @question = Question.new(question_params)
    @question.survey_id = params[:survey_id]
    save_question
  end

  #
  # Show route - fringe case: invalid edit submission followed by cancel attempts to render showpage
  #
  def show
    redirect_to presentation_survey_path(params[:presentation_id], params[:survey_id])
  end

  #
  # Index route - fringe case: invalid new submission followed by cancel attempts to render indexpage
  #
  def index
    redirect_to presentation_survey_path(params[:presentation_id], params[:survey_id])
  end

  #
  # Edit route
  #
  def edit
    set_instance_variables
  end

  #
  # Update route
  #
  def update
    set_instance_variables

    if @question.update(question_params)
      flash[:success] = success_message(@question, :update)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    else
      flash.now[:error] = error_message(@question, :update)
      render :edit
    end
  end

  #
  # Destroy route
  #
  def destroy
    set_instance_variables

    if @question.destroy
      flash[:success] = success_message(@question, :delete)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    else
      flash[:error] = error_message(@question, :delete)
      redirect_back fallback_location: presentations_path
    end
  end

  private

  #
  # Set and sanitize question params
  #
  def question_params
    params.require(:question).permit(:position, :prompt, :response_type, :response_required)
  end

  #
  # Set presentation to be used in routes
  #
  def set_presentation
    @presentation = Presentation.find(params[:presentation_id])
  end

  #
  # Define instance variables
  #
  def set_instance_variables
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.find(params[:id])
  end

  #
  # Save helper for create action
  # Extrapolated into new method to appease Rubocop
  #
  def save_question
    if @question.save
      flash[:success] = success_message(@question, :create)
      redirect_to presentation_survey_path(@presentation.id, @question.survey_id)
    else
      flash.now[:error] = error_message(@question, :create)
      render :new
    end
  end
end
