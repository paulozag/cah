class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :question_cards
  has_many :answer_cards
end
