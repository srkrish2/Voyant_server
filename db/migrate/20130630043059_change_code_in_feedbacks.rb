class ChangeCodeInFeedbacks < ActiveRecord::Migration
  def up
    change_column :element_feedbacks, :code, :string, :null => true, :default => nil
    change_column :first_notice_feedbacks, :code, :string, :null => true, :default => nil
    change_column :impression_feedbacks, :code, :string, :null => true, :default => nil
    change_column :goal_feedbacks, :code, :string, :null => true, :default => nil
    change_column :guideline_feedbacks, :code, :string, :null => true, :default => nil
  end

  def down
  end
end
