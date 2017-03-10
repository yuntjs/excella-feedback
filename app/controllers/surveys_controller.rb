class SurveysController < ApplicationController
  def index
    @presentation = Presentation.find(params[:presentation_id])
  end

  def new
    @presentation = Presentation.find(params[:presentation_id])
    @survey = @presentation.surveys.new
  end

  def create
    @presentation = Presentation.find(params[:presentation_id])
    @survey = @presentation.surveys.new(survey_params)
    if @survey.save
      flash[:success] = success_message(@survey, :create)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    elsif
      flash.now[:error] = error_message(@survey, :create)
      render :new
    end
  end

  def show
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])
  end

  def edit
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])
  end

  def update
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])

    if @survey.update(survey_params)
      flash[:success] = success_message(@survey, :update)
      redirect_to presentation_survey_path(@presentation.id, @survey.id)
    else
      flash.now[:error] = error_message(@survey, :create)
      render :edit
    end
  end

  def destroy
    @presentation = Presentation.find(params[:presentation_id])
    @survey = Survey.find(params[:id])

    if @survey.destroy
      flash[:success] = success_message(@survey, :delete)
      redirect_to presentation_surveys_path
    else
      flash[:error] = error_message(@question, :delete)
      redirect_back fallback_location: presentation_survey_path(@presentation.id, @survey.id)
    end
  end

  private

    def survey_params
      params.require(:survey).permit(:presentation_id, :order, :subject, :position)
    end
end
