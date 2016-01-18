class CreateAnswerDecks < ActiveRecord::Migration
  def change
    create_table :answer_decks do |t|
      t.references :game

      t.timestamps null: false
    end
  end
end
