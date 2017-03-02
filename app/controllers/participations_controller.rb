class ParticipationsController < ApplicationController
  before_action :set_participation, only: [:update]

  def update
    if @participation.update(participation_params)
      redirect_to presentation_path(params[:presentation_id]), notice: 'Participation was successfully updated.'
    else
      render presentation_path(params[:presentation_id])
    end
  end

  private
  def set_participation
    @participation = Participation.find(params[:id])
  end

  def participation_params
    params.require(:participation).permit(:user_id, :presentation_id, :is_presenter)
  end

end
