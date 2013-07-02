class AddFeedbackSurveyIdToBoxareas < ActiveRecord::Migration
  def change
    add_column :boxareas, :feedback_survey_id, :integer
  end
end
