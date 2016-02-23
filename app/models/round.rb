class Round < ActiveRecord::Base
  belongs_to :game
  has_one :answer_card
  serialize :player_answers, Hash

  def question_card
    QuestionCard.find(self.question_card_id)
  end

  def answer_card
    AnswerCard.find(self.answer_card_id)
  end
end
