class AddIsFeedbackDoneToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :is_feedback_done, :boolean, :default => false
  end
end
