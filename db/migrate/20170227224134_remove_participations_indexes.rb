class RemoveParticipationsIndexes < ActiveRecord::Migration[5.0]
  def change
    remove_index :participations, :user_id
    remove_index :participations, :presentation_id
  end
end
