class AddImpressionVoteFeedbacksAccessCodeToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :impression_vote_feedbacks_access_code, :string
  end
end
