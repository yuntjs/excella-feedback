#
# ParticipationsController
#
class ParticipationsController < ApplicationController
  before_action :authenticate_admin, only: [:update]
  before_action :set_participation, only: [:update]

  #
  # Update route
  #
  def update
    if @participation.update(participation_params)
      binding.pry
      if participation_params[:is_presenter] == "true" # Why is this a string?
        create_default_presenter_survey(User.find(@participation.user_id))
      end
      redirect_to presentation_path(params[:presentation_id]), notice: 'Participation was successfully updated.'
    else
      render presentation_path(params[:presentation_id])
    end
  end

  private

  #
  # Set Participation to be used in routes
  #
  def set_participation
    @participation = Participation.find(params[:id])
  end

  #
  # Set and sanitaize participation params
  #
  def participation_params
    params.require(:participation)
          .permit(:user_id, :presentation_id, :is_presenter)
  end

  #
  # Create default survey for presentation
  # Default questions in Question Model
  #
  def create_default_presenter_survey(presenter)
    survey = Presentation.find(@participation.presentation_id).surveys.create(subject: "Feedback for #{presenter.full_name}")
    Question.default_presenter_questions(presenter).each do |question|
      Question.create(survey_id: survey.id,
                   prompt: question[:prompt],
                   response_type: question[:response_type])
    end
  end
end
