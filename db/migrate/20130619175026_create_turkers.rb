class CreateTurkers < ActiveRecord::Migration
  def change
    create_table :turkers do |t|
      t.integer :age, :require => true
      t.integer :gender, :default => 0
      t.string :country, :require => true
      t.integer :design_experience, :default => 0

      t.timestamps
    end
  end
end
