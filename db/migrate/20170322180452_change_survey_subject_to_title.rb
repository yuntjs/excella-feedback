class ChangeSurveySubjectToTitle < ActiveRecord::Migration[5.0]
  def change
    remove_column :surveys, :subject
    add_column :surveys, :title, :string
  end
end
