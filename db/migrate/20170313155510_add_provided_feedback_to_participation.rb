class AddProvidedFeedbackToParticipation < ActiveRecord::Migration[5.0]
  def change
    add_column :participations, :feedback_provided, :boolean, default: false
  end
end
