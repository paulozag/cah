class CreateMasterAnswers < ActiveRecord::Migration
  def change
    create_table :master_answers do |t|
      t.string :text

      t.timestamps null: false
    end
  end
end
