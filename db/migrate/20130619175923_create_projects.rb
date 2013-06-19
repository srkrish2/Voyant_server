class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :user, :require => true
      t.string :name, :require => true
      t.text :description

      t.timestamps
    end
  end
end
