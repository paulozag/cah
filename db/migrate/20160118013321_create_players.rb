class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :game
      t.references :user

      t.timestamps null: false
    end
  end
end
