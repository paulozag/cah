class CreateMasterTopics < ActiveRecord::Migration
  def change
    create_table :master_topics do |t|
      t.text :text
      t.integer :num_responses

      t.timestamps null: false
    end
  end
end
