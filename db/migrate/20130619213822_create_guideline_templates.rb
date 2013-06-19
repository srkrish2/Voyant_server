class CreateGuidelineTemplates < ActiveRecord::Migration
  def change
    create_table :guideline_templates do |t|
      t.references :user, :null => false
      t.string :title, :null => false
      t.text :description

      t.timestamps
    end
  end
end
