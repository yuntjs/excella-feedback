class AddDefaultValueToParticipationIsPresenter < ActiveRecord::Migration[5.0]
  def change
    change_column :participations, :is_presenter, :boolean, default: false
  end
end
