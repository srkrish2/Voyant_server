class AddDesignIdToFeedbackSurveys < ActiveRecord::Migration
  def change
    add_column :feedback_surveys, :design_id, :integer
  end
end
