class AddIsPublishedToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :is_published, :boolean, :default => false
  end
end
