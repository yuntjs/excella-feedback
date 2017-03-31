class CreateSurveyTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_templates do |t|
      t.string :title
      t.string :name

      t.timestamps
    end
  end
end