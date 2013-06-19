class CreateFirstNoticeFeedbacks < ActiveRecord::Migration
  def change
    create_table :first_notice_feedbacks do |t|
      t.references :design, :null => false
      t.references :element_feedback, :null => false

      t.timestamps
    end
  end
end
