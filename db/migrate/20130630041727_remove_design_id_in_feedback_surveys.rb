class RemoveDesignIdInFeedbackSurveys < ActiveRecord::Migration
  def up
    remove_column :feedback_surveys, :design_id
  end

  def down
    add_column :feedback_surveys, :design_id, :integer
  end
end
