class CreateElementFeedbacks < ActiveRecord::Migration
  def change
    create_table :element_feedbacks do |t|
      t.references :design, :null => false
      t.references :configuration, :null => false
      t.string :name, :null => false
      t.integer :vote, :default => 0

      t.timestamps
    end
  end
end
