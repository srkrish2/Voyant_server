class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :user, :null => false
      t.string :name, :null => false
      t.text :description

      t.timestamps
    end
  end
end
