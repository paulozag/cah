class Game < ActiveRecord::Base
  has_many :players
  has_many :rounds
  has_one :question_deck
  has_one :answer_deck
  has_one :answer_discard_pile
  has_one :question_discard_pile

  after_save :intitialize_game_objects

  scope :ready_for_players, -> { where(status: :loading)}



  def intitialize_game_objects

  end
end
