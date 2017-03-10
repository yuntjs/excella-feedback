class AddPositionToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :position, :integer
  end
end
