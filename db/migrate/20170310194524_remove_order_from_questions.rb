class RemoveOrderFromQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :order, :integer
  end
end
