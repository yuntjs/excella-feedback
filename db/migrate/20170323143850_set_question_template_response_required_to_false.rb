class SetQuestionTemplateResponseRequiredToFalse < ActiveRecord::Migration[5.0]
  def change
    remove_column :question_templates, :response_required
    add_column :question_templates, :response_required, :boolean, default: false
  end
end
