module Presentationable
  extend ActiveSupport::Concern

  private

    def presentations
      if current_user.is_admin
        @presentations ||= Presentation.all
      else
        @presentations = current_user.presentations
      end
    end

    def presentation
      @presentation = load_presentation
    end

    def load_presentation
      blank_presentation || found_presentation || created_presentation || nil
    end

    def blank_presentation
      %w(new).include?(params[:action]) && Presentation.find(params[:presentation_id]) && Presentation.new
    end

    def found_presentation
      %w(show edit update).include?(params[:action]) && Presentation.find(params[:presentation_id])
    end

    def created_presentation
      %w(create).include?(params[:action]) && Presentation.new(presentation_params)
    end

    def presentation_params
      params.require(:presentation).permit(:title, :location, :date, :description, :is_published)
    end


    def set_presentation
      @presentation = Presentation.find(params[:id])
    end


end
