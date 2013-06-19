class CreateElementConfigurations < ActiveRecord::Migration
  def change
    create_table :element_configurations do |t|
      t.references :design, :null => false
      t.string :name, :null => false
      t.boolean :is_required, :default => true
      t.integer :turker_num, :default => 0
      t.float :turker_price, :default => 0

      t.timestamps
    end
  end
end
