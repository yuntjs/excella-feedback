class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.references :presentation, foreign_key: true
      t.integer :order
      t.string :subject

      t.timestamps
    end
  end
end
