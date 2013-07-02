class CreateFeedbackSurveys < ActiveRecord::Migration
  def change
    create_table :feedback_surveys do |t|
      t.string :code, :null => false
      t.integer :design_id, :null => false
      t.string :feedback_type
      t.integer :feedback_id

      t.timestamps
    end
  end
end
