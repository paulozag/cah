class QuestionCard < ActiveRecord::Base
  belongs_to :question_deck
  belongs_to :player, class_name: :winner
  belongs_to :master_question
  belongs_to :question_discard_pile
  has_one :round



end
