class AddFeedbackTurkeeTaskIdToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :element_feedbacks_hit_id, :integer
    add_column :designs, :first_notice_feedbacks_hit_id, :integer
    add_column :designs, :impression_feedbacks_hit_id, :integer
    add_column :designs, :impression_vote_feedbacks_hit_id, :integer
    add_column :designs, :goal_feedbacks_hit_id, :integer
    add_column :designs, :guideline_feedbacks_hit_id, :integer
  end

end
