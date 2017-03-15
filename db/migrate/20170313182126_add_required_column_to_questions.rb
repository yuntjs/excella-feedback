class AddRequiredColumnToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :response_required, :boolean, default: false
  end
end
