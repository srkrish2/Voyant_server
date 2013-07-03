class AddEmailToTurkers < ActiveRecord::Migration
  def change
    add_column :turkers, :email, :string
  end
end
