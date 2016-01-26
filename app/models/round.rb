class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :player, class_name: :judge
  belongs_to :player, class_name: :winner
  belongs_to :
end
