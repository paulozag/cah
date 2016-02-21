class Round < ActiveRecord::Base
  belongs_to :game

  def question_card
    QuestionCard.find(self.question_card_id)
  end
end
