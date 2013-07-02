class AddFeedbackControllerToFeedbackSurveys < ActiveRecord::Migration
  def change
    add_column :feedback_surveys, :feedback_controller, :string
  end
end
