class AddFeedbacksNumToElementConfigurations < ActiveRecord::Migration
  def change
    add_column :element_configurations, :feedbacks_num, :integer, :default => 5
  end
end
