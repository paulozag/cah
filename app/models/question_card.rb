class QuestionCard < ActiveRecord::Base
  belongs_to :game
  belongs_to :question_deck
  belongs_to :player
  belongs_to :master_question
  belongs_to :question_discard_pile
  has_one :round

  def text
    MasterQuestion.find(self.master_question_id).text
  end
end
