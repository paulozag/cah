class CreateQuestionDecks < ActiveRecord::Migration
  def change
    create_table :question_decks do |t|
      t.references :game

      t.timestamps null: false
    end
  end
end
