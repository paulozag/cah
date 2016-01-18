class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|


      t.timestamps null: false
    end
  end
end
