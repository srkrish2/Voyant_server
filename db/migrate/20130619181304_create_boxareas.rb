class CreateBoxareas < ActiveRecord::Migration
  def change
    create_table :boxareas do |t|
      t.references :turker, :require => true
      t.references :feedback, :polymorphic => true, :require => true

      t.float :top_left_x, :require => true
      t.float :top_left_y, :require => true
      t.float :bottom_right_x, :require => true
      t.float :bottom_right_y, :require => true

      t.text :description

      t.timestamps
    end
  end
end
