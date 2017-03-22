class CreateQuestionTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :question_templates do |t|
      t.string :prompt
      t.string :response_type
      t.boolean :response_required
      t.references :survey_template, foreign_key: true

      t.timestamps
    end
  end
end
