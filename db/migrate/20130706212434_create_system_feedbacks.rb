class CreateSystemFeedbacks < ActiveRecord::Migration
  def change
    create_table :system_feedbacks do |t|
      t.string :user_type
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end
end
