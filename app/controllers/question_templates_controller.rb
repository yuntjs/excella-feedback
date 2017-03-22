#
# QuestionTemplatesController
#
class QuestionTemplatesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_survey_template
  #
  # Render Survey Template data
  #
  def new
    @question_template = QuestionTemplate.new
  end

  #
  # Create route
  #
  def create
    @question_template = @survey_template.question_templates.new(question_template_params)
    save_question_template
  end

  #
  # Update route
  #
  def update
  end

  #
  # Destroy route
  #
  def destroy
  end

  private

  #
  # Set params for question_template
  #
  def question_template_params
    params.require(:question_template).permit(:prompt, :response_type, :response_required)
  end

  #
  # Set survey_template for question_template
  #
  def set_survey_template
    @survey_template = SurveyTemplate.find(params[:survey_template_id])
  end

  #
  # Save helper for create action
  # Extrapolated into new method to appease Rubocop
  #
  def save_question_template
    if @question_template.save
      flash[:success] = success_message(@question_template, :create)
      redirect_to survey_template_path(@survey_template)
    else
      flash.now[:error] = error_message(@question_template, :create)
      render :new
    end
  end
end
