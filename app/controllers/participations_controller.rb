class ParticipationsController < ApplicationController

  def create
    @presentation = Presentation.find params[:presentation_id]
    @user = User.find params[:user_id]

    participation = Participation.new(user: @user, presentation: @presentation, is_presenter: false)
    if participation.save
      redirect_to :back
    elsif
      redirect_to @presentation
    end
  end

end
