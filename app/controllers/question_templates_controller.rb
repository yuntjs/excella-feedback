#
# QuestionTemplatesController
#
class QuestionTemplatesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_survey_template

  #
  # Show
  #
  def show
    redirect_to survey_template_path(@survey_template)
  end

  #
  # New
  #
  def new
    @question_template = @survey_template.question_templates.new
  end

  #
  # Create
  #
  def create
    @question_template = @survey_template.question_templates.new(question_template_params)
    create_question_template
  end

  #
  # Edit
  #
  def edit
    @question_template = @survey_template.question_templates.find_by(id: params[:id])
  end

  #
  # Update
  #
  def update
    @question_template = @survey_template.question_templates.find_by(id: params[:id])
    update_question_template
  end

  #
  # Destroy
  #
  def destroy
    @question_template = @survey_template.question_templates.find(params[:id])
    delete_question_template
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
  # Logic helper for create action
  #
  def create_question_template
    if @question_template.save
      flash[:success] = success_message(@question_template, :create)
      redirect_to survey_template_path(@survey_template)
    else
      flash[:error] = error_message(@question_template, :create)
      render :new
    end
  end

  #
  # Logic helper for update action
  #
  def update_question_template
    if @question_template.update(question_template_params)
      flash[:success] = success_message(@question_template, :update)
      redirect_to survey_template_path(@survey_template)
    else
      flash[:error] = error_message(@question_template, :update)
      render :edit
    end
  end

  #
  # Logic helper for destroy action
  #
  def delete_question_template
    if @question_template.destroy
      flash[:success] = success_message(@question_template, :delete)
    else
      flash[:error] = error_message(@question_template, :delete)
    end

    redirect_to survey_template_path(@survey_template)
  end
end
