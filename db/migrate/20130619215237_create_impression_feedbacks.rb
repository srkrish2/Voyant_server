class CreateImpressionFeedbacks < ActiveRecord::Migration
  def change
    create_table :impression_feedbacks do |t|
      t.references :design, :null => false
      t.string :name, :null => false
      t.integer :vote, :default => 0

      t.timestamps
    end
  end
end
