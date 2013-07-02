class AddCodeToBoxareas < ActiveRecord::Migration
  def change
    add_column :boxareas, :code, :string
  end
end
