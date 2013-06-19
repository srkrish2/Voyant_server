class AddDesignExperienceToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :design_experience, :default => 0
    end
  end
end
