class RemoveOrderFromSurveys < ActiveRecord::Migration[5.0]
  def change
    remove_column :surveys, :order, :integer
  end
end
