class QuestionDeck < ActiveRecord::Base
  belongs_to :game
  has_many :question_cards
end
