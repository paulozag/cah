class AnswerDiscardPile < ActiveRecord::Base
  belongs_to :game
  has_many :answer_cards
end
