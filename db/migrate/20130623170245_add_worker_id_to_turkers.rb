class AddWorkerIdToTurkers < ActiveRecord::Migration
  def change
    add_column :turkers, :worker_id, :string
  end
end
