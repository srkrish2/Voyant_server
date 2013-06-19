class CreateBoxareas < ActiveRecord::Migration
  def change
    create_table :boxareas do |t|
      t.references :turker, :null => false
      t.references :feedback, :polymorphic => true, :null => false

      t.float :top_left_x, :null => false
      t.float :top_left_y, :null => false
      t.float :bottom_right_x, :null => false
      t.float :bottom_right_y, :null => false

      t.text :description

      t.timestamps
    end
  end
end
