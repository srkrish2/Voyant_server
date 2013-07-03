class AddFeedbacksNumToGoalConfigurations < ActiveRecord::Migration
  def change
    add_column :goal_configurations, :feedbacks_num, :integer, :default => 20
  end
end
