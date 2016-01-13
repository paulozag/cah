class CreateMasterTopics < ActiveRecord::Migration
  def change
    create_table :master_topics do |t|

      t.timestamps null: false
    end
  end
end
