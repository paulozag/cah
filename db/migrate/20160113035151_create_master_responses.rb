class CreateMasterResponses < ActiveRecord::Migration
  def change
    create_table :master_responses do |t|
      t.text :text

      t.timestamps null: false
    end
  end
end
