class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status, default: 'loading'
      t.integer :round_number, default: 1
      t.integer :winner_id
      t.integer :judge_id
      t.string :game_key
      t.integer :creator_id
      t.text :player_array, array: true, default: []


      t.timestamps null: false
    end
  end
end
