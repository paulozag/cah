class CreateAnswerCards < ActiveRecord::Migration
  def change
    create_table :answer_cards do |t|
      t.references :game
      t.references :player
      t.references :answer_deck
      t.references :answer_discard_pile
      t.boolean :excluded, default: false
      t.references :master_answer

      t.timestamps null: false
    end
  end
end
