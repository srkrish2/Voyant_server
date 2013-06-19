class CreateDesigns < ActiveRecord::Migration
  def change
    create_table :designs do |t|
      t.references :project
      t.references :user, :null => false
      t.string :name, :null => false
      t.text :description

      t.timestamps
    end
  end
end
