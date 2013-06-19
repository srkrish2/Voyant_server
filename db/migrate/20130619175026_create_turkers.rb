class CreateTurkers < ActiveRecord::Migration
  def change
    create_table :turkers do |t|
      t.integer :age, :null => false
      t.integer :gender, :default => 0
      t.string :country, :null => false
      t.integer :design_experience, :default => 0

      t.timestamps
    end
  end
end
