module Questionable
  extend ActiveSupport::Concern

  private

  def question
    @question ||= load_question
  end

  def load_question
    blank_question || found_question || created_question || nil
  end

  def blank_question
    %(new).include?(params[:action]) && Question.new
  end

  def found_question
    %w(show edit update).include?(params[:action]) && @survey.questions.find(params[:id])
  end

  def created_question
    %w(create).include?(params[:action]) && Question.new(question_params)
  end

  def question_params
    params.require(:question).permit(:order, :prompt, :response_type)
  end

end
