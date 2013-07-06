class AddFeedbacksNumToFirstNoticeConfigurations < ActiveRecord::Migration
  def change
    add_column :first_notice_configurations, :feedbacks_num, :integer, :default => 30
  end
end
