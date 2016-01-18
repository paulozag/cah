class CreateAnswerDiscardPiles < ActiveRecord::Migration
  def change
    create_table :answer_discard_piles do |t|
      t.references :game

      t.timestamps null: false
    end
  end
end
