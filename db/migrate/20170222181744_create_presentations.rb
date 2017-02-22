class CreatePresentations < ActiveRecord::Migration[5.0]
  def change
    create_table :presentations do |t|
      t.string :title
      t.datetime :date
      t.string :location
      t.text :description
      t.boolean :is_published

      t.timestamps
    end
  end
end
