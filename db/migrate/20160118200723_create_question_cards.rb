class CreateQuestionCards < ActiveRecord::Migration
  def change
    create_table :question_cards do |t|
      t.references :player
      t.references :game
      t.references :question_deck
      t.references :question_discard_pile
      t.boolean :excluded, default: false
      t.references :master_question

      t.timestamps null: false
    end
  end
end
