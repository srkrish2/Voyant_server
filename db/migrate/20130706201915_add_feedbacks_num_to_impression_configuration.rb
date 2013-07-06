class AddFeedbacksNumToImpressionConfiguration < ActiveRecord::Migration
  def change
    add_column :impression_configurations, :feedbacks_num, :integer, :default => 20
    add_column :impression_configurations, :feedbacks_vote_num, :integer, :default => 30
  end
end
