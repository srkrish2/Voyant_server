class CreateFeedbackCodes < ActiveRecord::Migration
  def change
    create_table :feedback_codes do |t|
      t.string :code, :null => false
      t.string :feedback_type, :null => false
      t.integer :feedback_id, :null => false

      t.timestamps
    end
  end
end
