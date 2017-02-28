class MakeParticipationsUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :participations, [:user_id, :presentation_id], name: 'add_index_to_participations', unique: true
  end
end
