class AddFeedbacksNumToGuidelineConfigurations < ActiveRecord::Migration
  def change
    add_column :guideline_configurations, :feedbacks_num, :integer, :default => 20
  end
end
