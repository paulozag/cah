class Round < ActiveRecord::Base
  belongs_to :game
  serialize :player_answers, Hash

  def question_card
    QuestionCard.find(self.question_card_id)
  end
end
