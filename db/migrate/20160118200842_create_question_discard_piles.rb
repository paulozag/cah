class CreateQuestionDiscardPiles < ActiveRecord::Migration
  def change
    create_table :question_discard_piles do |t|
      t.references :game

      t.timestamps null: false
    end
  end
end
