class AnswerCard < ActiveRecord::Base
  belongs_to :game
  belongs_to :answer_deck
  belongs_to :player
  belongs_to :answer_discard_pile
  belongs_to :master_answer
  belongs_to :round

  def text
    MasterAnswer.find(self.master_answer.id).text
  end
end
