class CreateGuidelineConfigurations < ActiveRecord::Migration
  def change
    create_table :guideline_configurations do |t|
      t.references :design, :null => false
      t.string :title, :null => false
      t.text :description

      t.boolean :is_required, :default => true
      t.integer :turker_num, :default => 0
      t.float :turker_price, :default => 0

      t.timestamps
    end
  end
end
