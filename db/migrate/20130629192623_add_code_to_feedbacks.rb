class AddCodeToFeedbacks < ActiveRecord::Migration
  def change
    add_column :element_feedbacks, :code, :string, :null => false, :default => "xxxxxxxxxxxxxxxx"
    add_column :first_notice_feedbacks, :code, :string, :null => false, :default => "xxxxxxxxxxxxxxxx"
    add_column :impression_feedbacks, :code, :string, :null => false, :default => "xxxxxxxxxxxxxxxx"
    add_column :goal_feedbacks, :code, :string, :null => false, :default => "xxxxxxxxxxxxxxxx"
    add_column :guideline_feedbacks, :code, :string, :null => false, :default => "xxxxxxxxxxxxxxxx"
  end
end
