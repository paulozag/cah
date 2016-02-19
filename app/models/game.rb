class Game < ActiveRecord::Base
  has_many :players
  has_many :rounds
  has_many :question_cards
  has_many :answer_cards
  has_one :question_deck
  has_one :answer_deck
  has_one :answer_discard_pile
  has_one :question_discard_pile

  after_create :intitialize_game_objects

  scope :ready_for_players, -> { where(status: :loading)}



  def intitialize_game_objects
    question_deck = QuestionDeck.create(game_id: self.id)
    answer_deck = AnswerDeck.create(game_id: self.id)
    question_discard_pile = QuestionDiscardPile.create(game_id: self.id)
    answer_discard_pile = AnswerDiscardPile.create(game_id: self.id)

    MasterQuestion.all.each do |mq|
      card = self.question_cards.create
      card.master_question_id = mq.id
      card.question_deck_id = question_deck.id
      card.save
    end

    MasterAnswer.all.each do |ma|
      card = self.answer_cards.create
      card.master_answer_id = ma.id
      card.answer_deck_id = answer_deck.id
      card.save
    end

  end
end
