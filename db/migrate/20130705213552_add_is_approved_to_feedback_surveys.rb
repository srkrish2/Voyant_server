class AddIsApprovedToFeedbackSurveys < ActiveRecord::Migration
  def change
    add_column :feedback_surveys, :is_approved, :boolean, :default => false
  end
end
