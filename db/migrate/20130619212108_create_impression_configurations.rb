class CreateImpressionConfigurations < ActiveRecord::Migration
  def change
    create_table :impression_configurations do |t|
      t.references :design, :null => false
      t.boolean :is_required, :default => true
      t.integer :turker_num1, :default => 0
      t.float :turker_price1, :default => 0
      t.integer :turker_num2, :default => 0
      t.float :turker_price2, :default => 0

      t.timestamps
    end
  end
end
