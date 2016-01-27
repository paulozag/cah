class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status
      t.integer :winner_id
      t.string :game_key
      t.integer :creator_id
      t.text :player_array, array: true, default: []


      t.timestamps null: false
    end
  end
end
