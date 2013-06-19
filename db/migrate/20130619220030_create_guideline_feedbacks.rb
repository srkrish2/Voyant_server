class CreateGuidelineFeedbacks < ActiveRecord::Migration
  def change
    create_table :guideline_feedbacks do |t|
      t.references :design, :null => false
      t.references :configuration, :null => false
      t.integer :rating, :default => 1

      t.timestamps
    end
  end
end
