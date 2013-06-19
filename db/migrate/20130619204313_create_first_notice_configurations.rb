class CreateFirstNoticeConfigurations < ActiveRecord::Migration
  def change
    create_table :first_notice_configurations do |t|
      t.references :design, :null => false
      t.boolean :is_required, :default => true
      t.integer :turker_num, :default => 0
      t.float :turker_price, :default => 0

      t.timestamps
    end
  end
end
