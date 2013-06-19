class CreateAudienceConfigurations < ActiveRecord::Migration
  def change
    create_table :audience_configurations do |t|
      t.references :design, :null => false
      t.string :gender, :null => false
      t.string :age, :null => false
      t.string :country, :null => false
      t.string :design_experience, :null => false

      t.timestamps
    end
  end
end
