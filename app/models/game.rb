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

  def draw_answer_card

    card = self.answer_deck.answer_cards.order("RANDOM()").first
    card.answer_deck_id = nil
    card.save
    if self.answer_deck.answer_cards.count == 0
      restock_answer_deck
    end
    card
  end

  def draw_question_card
    card = self.question_deck.question_cards.order("RANDOM()").first
    card.question_deck_id = nil
    card.save
    if self.question_deck.question_cards.count == 0
      restock_question_deck
    end
    card
  end

  def start_game
    deal_starting_answer_cards
  end


  private
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

  def restock_answer_deck
  end

  def restock_question_deck
  end

  def deal_starting_answer_cards
    self.players.each do |player|
      10.times do
        card = self.draw_answer_card
        card.player_id = player.id
        card.save
      end
    end
  end
end
