class AddFeedbackAccessCodeToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :element_feedbacks_access_code, :string
    add_column :designs, :first_notice_feedbacks_access_code, :string
    add_column :designs, :impression_feedbacks_access_code, :string
    add_column :designs, :goal_feedbacks_access_code, :string
    add_column :designs, :guideline_feedbacks_access_code, :string
  end
end
