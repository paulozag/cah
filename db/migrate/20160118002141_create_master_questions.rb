class CreateMasterQuestions < ActiveRecord::Migration
  def change
    create_table :master_questions do |t|
      t.string :text
      t.string :needs_back

      t.timestamps null: false
    end
  end
end
