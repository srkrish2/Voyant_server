class AddPictureToDesigns < ActiveRecord::Migration
  def self.up
    add_attachment :designs, :picture
  end

  def self.down
    remove_attachment :designs, :picture
  end
end
