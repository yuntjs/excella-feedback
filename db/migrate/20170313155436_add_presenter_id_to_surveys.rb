class AddPresenterIdToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :presenter_id, :integer
  end
end
