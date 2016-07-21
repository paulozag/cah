class AddPointLimitToGames < ActiveRecord::Migration
  def change
    add_column :games, :point_limit, :integer
  end
end
