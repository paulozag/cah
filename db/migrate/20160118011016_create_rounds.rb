class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :phase, default: 'start'
      t.references :game
      t.integer :round_number
      t.integer :judge_id
      t.integer :winner_id
      t.references :question_card
      t.text :player_answers, hash: true, defalut: {}

      t.timestamps null: false
    end
  end
end
