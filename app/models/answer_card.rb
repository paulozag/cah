class AnswerCard < ActiveRecord::Base
  belongs_to :game
  belongs_to :answer_deck
  belongs_to :player
  belongs_to :answer_discard_pile
  belongs_to :master_answer
  has_one :round
end
